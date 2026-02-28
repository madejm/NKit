import Foundation
#if canImport(AppKit)
import AppKit

open class NScrollView: NSScrollView {
    
    private var widthConstraint: NSLayoutConstraint?
    
    public init(
        axes: Axis = .both,
        showsIndicators: Bool = true,
        _ content: NSView
    ) {
        super.init(frame: .zero)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        self.documentView = content
        
        NSLayoutConstraint.activate {
            NEdge.Set(.top, .leading).constraints(superview: self.contentView, subview: content)
            
            if axes.contains(.horizontal) {
                NDimmension.width.constraint(superview: self.contentView, subview: content, symbol: .less)
                NDimmension.width.constraint(superview: self.contentView, subview: content, priority: NKitDefaults.scrollViewContentLayoutPriority)
            } else {
                NDimmension.width.constraint(superview: self.contentView, subview: content)
            }
            
            if axes.contains(.vertical) {
                NDimmension.height.constraint(superview: self.contentView, subview: content, symbol: .less)
                NDimmension.height.constraint(superview: self.contentView, subview: content, priority: NKitDefaults.scrollViewContentLayoutPriority)
            } else {
                NDimmension.height.constraint(superview: self.contentView, subview: content)
            }
        }
        
        self.hasHorizontalScroller = showsIndicators && axes.contains(.horizontal)
        self.hasVerticalScroller = showsIndicators && axes.contains(.vertical)
        self.autohidesScrollers = true
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    public override func viewDidMoveToWindow() {
//        super.viewDidMoveToWindow()
//        
//        guard let superview else {
//            return
//        }
//        
//        var parent: NSView = superview
//        var child: NSView = self
//        
//        while true {
//            if let stack = parent as? NSStackView {
//                if stack.orientation == .vertical {
//                    break
//                } else {
//                    return
//                }
//            }
//            guard let newSuperview = parent.superview else {
//                break
//            }
//            child = parent
//            parent = newSuperview
//        }
//        
//        widthConstraint = parent.widthAnchor.constraint(equalTo: child.widthAnchor, multiplier: 1.0)
//        widthConstraint?.isActive = true
//    }
    
//    public override func removeFromSuperview() {
//        widthConstraint?.isActive = false
//        widthConstraint = nil
//        
//        super.removeFromSuperview()
//    }
}
#endif
