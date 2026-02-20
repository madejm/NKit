import Foundation
import Combine
#if canImport(UIKit)
import UIKit

extension UIViewController {
    
    nonisolated(unsafe) 
    private static var swizzledLifecycle: Bool = false
    
    nonisolated
    internal static func swizzleLifecycleIfNeeded() {
        guard !Self.swizzledLifecycle else {
            return
        }
        Self.swizzledLifecycle = true
        
        swizzle(
            selector: #selector(UIViewController.viewDidLoad),
            with: #selector(UIViewController.swizzled_viewDidLoad),
            on: UIViewController.self
        )
        swizzle(
            selector: #selector(UIViewController.viewWillAppear(_:)),
            with: #selector(UIViewController.swizzled_viewWillAppear(_:)),
            on: UIViewController.self
        )
        swizzle(
            selector: #selector(UIViewController.viewDidAppear(_:)),
            with: #selector(UIViewController.swizzled_viewDidAppear(_:)),
            on: UIViewController.self
        )
        swizzle(
            selector: #selector(UIViewController.viewWillDisappear(_:)),
            with: #selector(UIViewController.swizzled_viewWillDisappear(_:)),
            on: UIViewController.self
        )
        swizzle(
            selector: #selector(UIViewController.viewDidDisappear(_:)),
            with: #selector(UIViewController.swizzled_viewDidDisappear(_:)),
            on: UIViewController.self
        )
    }
    
    @objc private func swizzled_viewDidLoad() {
        self[associatedId: .viewControllerLifecycle] = .didLoad
        
        self.swizzled_viewDidLoad()
        self.view.setParent(self, isRootView: true)
    }
    
    @objc private func swizzled_viewWillAppear(_ animated: Bool) {
        self[associatedId: .viewControllerLifecycle] = .willAppear
        
        self[associatedId: .viewWillAppearId].send()
        self.swizzled_viewWillAppear(animated)
    }
    
    @objc private func swizzled_viewDidAppear(_ animated: Bool) {
        self[associatedId: .viewControllerLifecycle] = .didAppear
        
        self.swizzled_viewDidAppear(animated)
        self[associatedId: .viewDidAppearId].send()
    }
    
    @objc private func swizzled_viewWillDisappear(_ animated: Bool) {
        self[associatedId: .viewControllerLifecycle] = .willDisappear
        
        self[associatedId: .viewWillDisappearId].send()
        self.swizzled_viewWillDisappear(animated)
    }
    
    @objc private func swizzled_viewDidDisappear(_ animated: Bool) {
        self[associatedId: .viewControllerLifecycle] = .didDisappear
        
        self.swizzled_viewDidDisappear(animated)
        self[associatedId: .viewDidDisappearId].send()
    }
}
#endif
