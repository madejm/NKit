import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NAnimation {
    public fileprivate(set) static var current: NAnimation? = nil
}
    
@MainActor
public func nWithAnimation(
    _ animation: NAnimation? = .default,
    _ body: @escaping () -> Void,
    completion: (() -> Void)? = nil
) {
    guard let animation else {
        return body()
    }
    
    #if canImport(AppKit)
    NSAnimationContext.runAnimationGroup { context in
        context.duration = animation.duration
        context.timingFunction = animation.timingFunction
        context.allowsImplicitAnimation = true
        context.completionHandler = completion
        
        NAnimation.current = animation
        body()
        NAnimation.current = nil
    }
    #elseif canImport(UIKit)
    UIView.animate(
        withDuration: animation.duration,
        delay: 0.0,
        options: [
            animation.timingFunctionName.animationOption
        ],
        animations: {
            NAnimation.current = animation
            body()
            NAnimation.current = nil
        },
        completion: { _ in
            completion?()
        }
    )
    #endif
}

@MainActor
public func nWithoutAnimation(
    _ body: () -> Void
) {
    #if canImport(AppKit)
    body()
    #elseif canImport(UIKit)
    UIView.performWithoutAnimation {
        body()
    }
    #endif
}

#if canImport(UIKit)
extension CAMediaTimingFunctionName {
    fileprivate var animationOption: UIView.AnimationOptions {
        switch self {
        case .easeIn:        .curveEaseIn
        case .easeOut:       .curveEaseOut
        case .easeInEaseOut: .curveEaseInOut
        case .linear:        .curveLinear
        default:             .curveLinear
        }
    }
}
#endif
