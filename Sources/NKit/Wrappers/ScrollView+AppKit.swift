import Foundation
#if canImport(AppKit)
import AppKit

open class ScrollView: NSScrollView {
    public struct Axis: OptionSet {
        nonisolated(unsafe) public static let horizontal = Axis(rawValue: 1 << 0)
        nonisolated(unsafe) public static let vertical = Axis(rawValue: 1 << 1)
        nonisolated(unsafe) public static let both: Axis = [.horizontal, .vertical]
        
        public let rawValue: Int8
        
        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }
    }
    
    private var widthConstraint: NSLayoutConstraint?
    
    public convenience init(
        axes: Axis = .both,
        _ content: () -> NSView
    ) {
        self.init(
            axes: axes,
            content()
        )
    }
    
    public init(
        axes: Axis = .both,
        _ content: NSView
    ) {
        super.init(frame: .zero)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        self.documentView = content
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: content.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            content.heightAnchor.constraint(greaterThanOrEqualTo: self.contentView.heightAnchor),
            content.widthAnchor.constraint(greaterThanOrEqualTo: self.contentView.widthAnchor)
        ])
        
        self.scrollerStyle = .overlay
        self.hasHorizontalScroller = axes.contains(.horizontal)
        self.hasVerticalScroller = axes.contains(.vertical)
        self.autohidesScrollers = true
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        guard let superview else {
            return
        }
        
        var parent: NSView = superview
        var child: NSView = self
        
        while true {
            if let stack = parent as? NSStackView {
                if stack.orientation == .vertical {
                    break
                } else {
                    return
                }
            }
            guard let newSuperview = parent.superview else {
                break
            }
            child = parent
            parent = newSuperview
        }
        
        widthConstraint = parent.widthAnchor.constraint(equalTo: child.widthAnchor, multiplier: 1.0)
        widthConstraint?.isActive = true
    }
    
    public override func removeFromSuperview() {
        widthConstraint?.isActive = false
        widthConstraint = nil
        
        super.removeFromSuperview()
    }
}
#endif
