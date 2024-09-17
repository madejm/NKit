import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public final class NGrid: BaseView {
    private struct WeakView {
        fileprivate weak var value: _View?
    }
    
    @NEnvironment(\.gridParent) private var gridParent
    private var guides: [WeakView] = []
    
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
    
    internal func equalSize(
        width: Bool,
        at index: Int,
        with anotherView: _View
    ) -> NSLayoutConstraint? {
        self.guides.removeAll {
            $0.value == nil
        }
        
        guard index < self.guides.count, let view: _View = self.guides[index].value else {
            self.guides.append(.init(value: anotherView))
            return nil
        }
        
        let constraint: NSLayoutConstraint
        
        if width {
            constraint = view.widthAnchor.constraint(equalTo: anotherView.widthAnchor)
        } else {
            constraint = view.heightAnchor.constraint(equalTo: anotherView.heightAnchor)
        }
        
        constraint.isActive = true
        return constraint
    }
}
