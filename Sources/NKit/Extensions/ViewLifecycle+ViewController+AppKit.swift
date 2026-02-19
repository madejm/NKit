import Foundation
import Combine
#if canImport(AppKit)
import AppKit

extension NSViewController {
    
    private static var swizzledLifecycle: Bool = false
    
    internal static func swizzleLifecycleIfNeeded() {
        guard !Self.swizzledLifecycle else {
            return
        }
        Self.swizzledLifecycle = true
        
        swizzle(
            selector: #selector(NSViewController.viewDidLoad),
            with: #selector(NSViewController.swizzled_viewDidLoad),
            on: NSViewController.self
        )
        swizzle(
            selector: #selector(NSViewController.viewWillAppear),
            with: #selector(NSViewController.swizzled_viewWillAppear),
            on: NSViewController.self
        )
        swizzle(
            selector: #selector(NSViewController.viewDidAppear),
            with: #selector(NSViewController.swizzled_viewDidAppear),
            on: NSViewController.self
        )
        swizzle(
            selector: #selector(NSViewController.viewWillDisappear),
            with: #selector(NSViewController.swizzled_viewWillDisappear),
            on: NSViewController.self
        )
        swizzle(
            selector: #selector(NSViewController.viewDidDisappear),
            with: #selector(NSViewController.swizzled_viewDidDisappear),
            on: NSViewController.self
        )
    }
    
    @objc private func swizzled_viewDidLoad() {
        self[associatedId: .viewControllerLifecycle] = .didLoad
        
        self.swizzled_viewDidLoad()
        self.view.setParent(self, isRootView: true)
    }
    
    @objc private func swizzled_viewWillAppear() {
        self[associatedId: .viewControllerLifecycle] = .willAppear
        
        self[associatedId: .viewWillAppearId].send()
        self.swizzled_viewWillAppear()
    }
    
    @objc private func swizzled_viewDidAppear() {
        self[associatedId: .viewControllerLifecycle] = .didAppear
        
        self.swizzled_viewDidAppear()
        self[associatedId: .viewDidAppearId].send()
    }
    
    @objc private func swizzled_viewWillDisappear() {
        self[associatedId: .viewControllerLifecycle] = .willDisappear
        
        self[associatedId: .viewWillDisappearId].send()
        self.swizzled_viewWillDisappear()
    }
    
    @objc private func swizzled_viewDidDisappear() {
        self[associatedId: .viewControllerLifecycle] = .didDisappear
        
        self.swizzled_viewDidDisappear()
        self[associatedId: .viewDidDisappearId].send()
    }
}
#endif
