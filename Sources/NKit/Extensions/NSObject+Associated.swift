import Foundation
import Combine

extension NSObject {
    internal enum AssociatedId {
        case gestureHandler
        case cancellables
        case tag
        
        nonisolated(unsafe) fileprivate static var _gestureHandler = "gestureHandler"
        nonisolated(unsafe) fileprivate static var _cancellables = "cancellables"
        nonisolated(unsafe) fileprivate static var _tag = "tag"
        
        fileprivate var key: UnsafeRawPointer {
            switch self {
            case .gestureHandler:
                return point(&AssociatedId._gestureHandler)
            case .cancellables:
                return point(&AssociatedId._cancellables)
            case .tag:
                return point(&AssociatedId._tag)
            }
        }
        
        private func point(_ me: UnsafeRawPointer) -> UnsafeRawPointer {
            me
        }
    }
    
    internal subscript<Value>(
        associatedId associatedId: AssociatedId
    ) -> Value? {
        get {
            objc_getAssociatedObject(self, associatedId.key) as? Value
        }
        set(newValue) {
            objc_setAssociatedObject(self, associatedId.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var cancellables: Set<AnyCancellable> {
        get {
            if let anyValue: Any? = self[associatedId: .cancellables],
               anyValue != nil {
                let value: Set<AnyCancellable> = anyValue as! Set<AnyCancellable>
                return value
            }
            
            let value: Set<AnyCancellable> = []
            self[associatedId: .cancellables] = value
            return value
        }
        set {
            self[associatedId: .cancellables] = newValue
        }
    }
}
