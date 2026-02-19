#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public enum NKitEngine {
    @MainActor
    public static func setupNKit() {
        _View.swizzleLifecycleIfNeeded()
        _ViewController.swizzleLifecycleIfNeeded()
    }
}
