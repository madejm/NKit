#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@_cdecl("setupNKit")
internal func setupNKit() {
    _View.swizzleLifecycleIfNeeded()
    _ViewController.swizzleLifecycleIfNeeded()
}
