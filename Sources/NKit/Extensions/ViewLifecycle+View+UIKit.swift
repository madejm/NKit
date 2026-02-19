import Foundation
import Combine
#if canImport(UIKit)
import UIKit

extension UIView {
    private static var swizzledLifecycle: Bool = false
    
    internal static func swizzleLifecycleIfNeeded() {
        guard !Self.swizzledLifecycle else {
            return
        }
        Self.swizzledLifecycle = true
        
        swizzle(
            selector: #selector(UIView.addSubview(_:)),
            with: #selector(UIView.swizzled_addSubview(_:)),
            on: UIView.self
        )
        swizzle(
            selector: #selector(UIView.willMove(toSuperview:)),
            with: #selector(UIView.swizzled_willMove(toSuperview:)),
            on: UIView.self
        )
        swizzle(
            selector: #selector(UIView.didMoveToSuperview),
            with: #selector(UIView.swizzled_didMoveToSuperview),
            on: UIView.self
        )
        swizzle(
            selector: #selector(UIView.willMove(toWindow:)),
            with: #selector(UIView.swizzled_willMove(toWindow:)),
            on: UIView.self
        )
        swizzle(
            selector: #selector(UIView.removeFromSuperview),
            with: #selector(UIView.swizzled_removeFromSuperview),
            on: UIView.self
        )
    }
    
    @objc private func swizzled_addSubview(_ view: UIView) {
        if let parent = self.getParent() {
            view.setParent(parent, isRootView: false)
        }
        
        self.swizzled_addSubview(view)
    }
    
    @objc private func swizzled_willMove(toSuperview newSuperview: UIView?) {
        self[associatedId: .viewWillMoveToSuperviewId].send()
        self.swizzled_willMove(toSuperview: newSuperview)
    }
    
    @objc private func swizzled_didMoveToSuperview() {
        self.swizzled_didMoveToSuperview()
        
        self[associatedId: .viewDidMoveToSuperviewId].send()
    }
    
    @objc private func swizzled_willMove(toWindow newWindow: UIWindow?) {
        self[associatedId: .viewWillMoveToWindowId].send()
        self.swizzled_willMove(toWindow: newWindow)
    }
    
    @objc private func swizzled_removeFromSuperview() {
        self.swizzled_removeFromSuperview()
        
        self.setParent(nil, isRootView: false)
        
        self[associatedId: .removeFromSuperviewId].send()
    }
}
#endif
