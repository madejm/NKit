import Foundation
import Combine
#if canImport(AppKit)
import AppKit

extension NSView {
    private static var swizzledLifecycle: Bool = false
    
    internal static func swizzleLifecycleIfNeeded() {
        guard !Self.swizzledLifecycle else {
            return
        }
        Self.swizzledLifecycle = true
        
        swizzle(
            selector: #selector(NSView.addSubview(_:)),
            with: #selector(NSView.swizzled_addSubview(_:)),
            on: NSView.self
        )
        swizzle(
            selector: #selector(NSView.viewWillMove(toSuperview:)),
            with: #selector(NSView.swizzled_viewWillMove(toSuperview:)),
            on: NSView.self
        )
        swizzle(
            selector: #selector(NSView.viewDidMoveToSuperview),
            with: #selector(NSView.swizzled_viewDidMoveToSuperview),
            on: NSView.self
        )
        swizzle(
            selector: #selector(NSView.viewWillMove(toWindow:)),
            with: #selector(NSView.swizzled_viewWillMove(toWindow:)),
            on: NSView.self
        )
        swizzle(
            selector: #selector(NSView.removeFromSuperview),
            with: #selector(NSView.swizzled_removeFromSuperview),
            on: NSView.self
        )
    }
    
    @objc private func swizzled_addSubview(_ view: NSView) {
        if let parent = self.getParent() {
            view.setParent(parent, isRootView: false)
        }
        
        self.swizzled_addSubview(view)
    }
    
    @objc private func swizzled_viewWillMove(toSuperview newSuperview: NSView?) {
        self[associatedId: .viewWillMoveToSuperviewId].send()
        self.swizzled_viewWillMove(toSuperview: newSuperview)
    }
    
    @objc private func swizzled_viewDidMoveToSuperview() {
        self.swizzled_viewDidMoveToSuperview()
        
        self[associatedId: .viewDidMoveToSuperviewId].send()
    }
    
    @objc private func swizzled_viewWillMove(toWindow newWindow: NSWindow?) {
        self[associatedId: .viewWillMoveToWindowId].send()
        self.swizzled_viewWillMove(toWindow: newWindow)
    }
    
    @objc private func swizzled_removeFromSuperview() {
        self.swizzled_removeFromSuperview()
        
        self.setParent(nil, isRootView: false)
        
        self[associatedId: .removeFromSuperviewId].send()
    }
}
#endif
