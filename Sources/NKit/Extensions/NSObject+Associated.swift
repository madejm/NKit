import Foundation

extension NSObject {
    internal subscript(associatedId associatedId: Int) -> Any? {
        get {
            var id: Int = associatedId
            return objc_getAssociatedObject(self, &id)
        }
        set(newValue) {
            var id: Int = associatedId
            objc_setAssociatedObject(self, &id, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
