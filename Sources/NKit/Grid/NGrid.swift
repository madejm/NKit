import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public final class NGrid: BaseView {
    @NEnvironment(\.gridParent) private var gridParent
    internal var guides: [_View] = []
    
    public init(
        _ content: () -> _View
    ) {
        super.init()
        
        let cont = content()
        self.addSubviewAutomatically(cont)
        self.gridParent = self
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        self.gridParent = nil
    }
}

public final class NGridRow: NHStack {
    @NEnvironment(\.gridParent) private var gridParent
    private var gridConstraints: [NSLayoutConstraint] = []
    
    public override init(
        alignment: Alignment = .center,
        spacing: CGFloat = 0,
        stretching: Stretching = .none,
        @NViewBuilder _ content: @escaping ViewCreator
    ) {
        super.init(
            alignment: alignment,
            spacing: spacing,
            stretching: stretching,
            content
        )
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        self.stack.arrangedSubviews
            .forEach {
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
                $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            }
        
        self.gridConstraints
            .forEach {
                $0.isActive = false
            }
        
        self.gridConstraints = self
            .stack
            .arrangedSubviews
            .enumerated()
            .compactMap() { index, view in
                self.gridParent?.guides.equalWidth(at: index, with: view)
            }
    }
}

internal struct GridEnvironmentKey: NEnvironmentKey {
    internal static let defaultValue: NGrid? = nil
}

extension NEnvironmentValues {
    internal var gridParent: NGrid? {
        get { self[GridEnvironmentKey.self] }
        set { self[GridEnvironmentKey.self] = newValue }
    }
}

extension Array where Element == _View {
    fileprivate mutating func equalWidth(
        at index: Int,
        with anotherView: _View
    ) -> NSLayoutConstraint? {
        guard index < self.count else {
            self.append(anotherView)
            return nil
        }
        
        let view: _View = self[index]
        
        let constraint: NSLayoutConstraint = view.widthAnchor.constraint(equalTo: anotherView.widthAnchor)
        constraint.isActive = true
        return constraint
    }
}
