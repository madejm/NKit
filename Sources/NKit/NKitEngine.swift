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

@MainActor
public enum NKitDefaults {
    /// Default spacing of `NHStack` and `NVStack`.
    public static var stackSpacing: CGFloat = 8
    
    /// Defines how stack hugs it's contents on macOS.
    /// Has no effect on iOS.
    public static var stackHugging: NStackHugging = .contentMaxSize
    
    internal static func stackHuggingLayoutPriority(for hugging: NStackHugging) -> NLayoutPriority {
        switch hugging {
        case .resize:         .fittingSize
//        case .contentMaxSize: .defaultLow
        case .contentMaxSize: .sizeStayPut
//        case .contentMaxSize: .dragThatCannotResize
        case .contentMinSize: .dragThatCanResize
        }
    }
    internal static func stackHuggingDirectionLayoutPriority(for hugging: NStackHugging) -> NLayoutPriority {
        switch hugging {
        case .resize:         .required
        case .contentMaxSize: .required
        case .contentMinSize: .required
        }
    }
    
    #if canImport(AppKit)
    internal static func stackSizeDirectionLayoutPriority(for hugging: NStackHugging) -> NLayoutPriority {
        switch hugging {
        case .resize:         .defaultLow
        case .contentMaxSize: .required
        case .contentMinSize: .required
        }
    }
    #endif
    internal static let stackFitLayoutPriority: NLayoutPriority = .defaultLow
    internal static let stackDimmensionLayoutPriority: NLayoutPriority = stackFitLayoutPriority - 1
    #if canImport(AppKit)
    internal static let scrollViewContentLayoutPriority: NLayoutPriority = .dragThatCannotResize
    #endif
}
