import Foundation

internal func swizzle(
    selector originalSelector: Selector,
    with swizzledSelector: Selector,
    on aClass: AnyClass
) {
    guard let originalMethod: Method = class_getInstanceMethod(aClass, originalSelector) else {
        return
    }
    guard let swizzledMethod: Method = class_getInstanceMethod(aClass, swizzledSelector) else {
        return
    }
    
    let didAddMethod: Bool = class_addMethod(
        aClass,
        originalSelector,
        method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod)
    )
    
    if didAddMethod {
        class_replaceMethod(
            aClass,
            swizzledSelector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod)
        )
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
