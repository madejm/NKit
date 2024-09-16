import Foundation
#if canImport(AppKit)
import AppKit

extension NSViewController {
    private static var swizzledEnv: Bool = false
    
    internal static func swizzleEnvIfNeeded() {
        guard !Self.swizzledEnv else {
            return
        }
        
        swizzle(
            selector: #selector(NSViewController.viewDidLoad),
            with: #selector(NSViewController.viewDidLoad_env),
            on: NSViewController.self
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

extension NSView {
    private static var swizzledEnv: Bool = false
    
    internal static func swizzleEnvIfNeeded() {
        guard !Self.swizzledEnv else {
            return
        }
        
        swizzle(
            selector: #selector(NSView.init(frame:)),
            with: #selector(NSView.init(env_frame:)),
//            selector: #selector(NSView.viewDidMoveToSuperview),
//            with: #selector(NSView.viewDidMoveToSuperview_env),
            on: NSView.self
        )
        
        Self.swizzledEnv = true
    }
    
    @objc
    private convenience init(env_frame frameRect: NSRect) {
        self.init(env_frame: frameRect)
//    private func viewDidMoveToSuperview_env() {
        self.ownables()
            .forEach {
                $0.owner = self
            }
        
//        self.viewDidMoveToSuperview_env()
    }
}
#endif
