import Foundation
#if canImport(UIKit)
import UIKit

extension UIViewController {
    private static var swizzledEnv: Bool = false
    
    internal static func swizzleEnvIfNeeded() {
        guard !Self.swizzledEnv else {
            return
        }
        
        swizzle(
            selector: #selector(UIViewController.viewDidLoad),
            with: #selector(UIViewController.viewDidLoad_env),
            on: UIViewController.self
        )
        
        Self.swizzledEnv = true
    }
    
    @objc
    private func viewDidLoad_env() {
        self.ownables()
            .forEach {
                $0.owner = self
            }
        
        self.viewDidLoad_env()
    }
}

extension UIView {
    private static var swizzledEnv: Bool = false
    
    internal static func swizzleEnvIfNeeded() {
        guard !Self.swizzledEnv else {
            return
        }
        
        swizzle(
            selector: #selector(UIView.didMoveToSuperview),
            with: #selector(UIView.didMoveToSuperview_env),
            on: UIView.self
        )
        
        Self.swizzledEnv = true
    }
    
    @objc
    private func didMoveToSuperview_env() {
        self.ownables()
            .forEach {
                $0.owner = self
            }
        
        self.didMoveToSuperview_env()
    }
}
#endif
