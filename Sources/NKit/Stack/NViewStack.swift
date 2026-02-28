import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// Defines how stack hugs it's contents on macOS.
public enum NStackHugging {
    /// Allows stack to add margins to it's contents.
    /// `NSWindow` can be resized to any size greater than it's content size.
    /// Mirrors behavior of SwiftUI.
    case resize
    
    /// Stack cannot have size greater than it's content size.
    /// `NSWindow` cannot be stretched to size greater than the content's size.
    /// Default, can be changed globally in `NKitDefaults.stackSpacing`.
    case contentMaxSize
    
    /// Stack cannot have size greater than it's content size.
    /// `NSWindow` cannot be stretched to size greater than the content's size.
    case contentMinSize
}

/// Base for stack views.
/// Do not use this class, instead use `NHStack` or `NVStack`.
public class NViewStack: BaseView {
    internal let stack: _StackView
    internal let content: /*@MainActor*/ () -> [NView]
    
    nonisolated(unsafe)
    internal var retainedDynamicViews: [NCacheable]?
    
    internal init(
        alignment: BaseAlignment,
        orientation: Orientation,
        spacing: CGFloat,
        hugging: NStackHugging,
        @NViewBuilder content: @escaping /*@MainActor*/ () -> [NView]
    ) {
        self.content = content
        self.stack = _StackView()
        
        super.init()
        
        self.stack.alignment = alignment
        self.stack.orientation = orientation
        self.stack.spacing = spacing
        self.stack.distribution = .fill
        
        #if canImport(AppKit)
        let stackHuggingPriority: NLayoutPriority = NKitDefaults.stackHuggingLayoutPriority(for: hugging)
        let stackHuggingDirectionPriority: NLayoutPriority = NKitDefaults.stackHuggingDirectionLayoutPriority(for: hugging)
        switch orientation {
        case .horizontal:
            self.stack.setHuggingPriority(stackHuggingDirectionPriority.priority, for: .horizontal)
            self.stack.setHuggingPriority(stackHuggingPriority.priority, for: .vertical)
        case .vertical:
            self.stack.setHuggingPriority(stackHuggingPriority.priority, for: .horizontal)
            self.stack.setHuggingPriority(stackHuggingDirectionPriority.priority, for: .vertical)
        @unknown default:
            break
        }
        #endif
        
        self.prepare()
    
        self.stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        
        switch orientation {
        case .horizontal:
            NSLayoutConstraint.activate([
                NEdge.top.constraint(superview: self, subview: stack),
                NEdge.bottom.constraint(superview: self, subview: stack)
            ])
            #if canImport(AppKit)
            NSLayoutConstraint.activate([
                NCenter.x.constraint(superview: self, subview: stack),
                NDimmension.width.constraint(superview: self, subview: stack, symbol: .greater),
                NDimmension.width.constraint(superview: self, subview: stack, priority: NKitDefaults.stackSizeDirectionLayoutPriority(for: hugging))
            ])
            #elseif canImport(UIKit)
            NSLayoutConstraint.activate([
                NEdge.leading.constraint(superview: self, subview: stack),
                NEdge.trailing.constraint(superview: self, subview: stack)
            ])
            #endif
        case .vertical:
            NSLayoutConstraint.activate([
                NEdge.leading.constraint(superview: self, subview: stack),
                NEdge.trailing.constraint(superview: self, subview: stack)
            ])
            #if canImport(AppKit)
            NSLayoutConstraint.activate([
                NCenter.y.constraint(superview: self, subview: stack),
                NDimmension.height.constraint(superview: self, subview: stack, symbol: .greater),
                NDimmension.height.constraint(superview: self, subview: stack, priority: NKitDefaults.stackSizeDirectionLayoutPriority(for: hugging))
            ])
            #elseif canImport(UIKit)
            NSLayoutConstraint.activate([
                NEdge.top.constraint(superview: self, subview: stack),
                NEdge.bottom.constraint(superview: self, subview: stack)
            ])
            #endif
        @unknown default:
            break
        }
        
        self.buildContent()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.retainedDynamicViews?.forEach {
            $0.releaseChecker.expect()
        }
    }
}
