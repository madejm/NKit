import Foundation
import Combine

internal struct AssociatedId<Value> {
    let key: String
}

extension AssociatedId where Value == Set<AnyCancellable> {
    internal static let cancellables: Self = .init(key: "cancellables")
}

extension NSObject {
    
    internal subscript<Value>(
        associatedId associatedId: AssociatedId<Value>
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
            if let value: Set<AnyCancellable> = self[associatedId: .cancellables] {
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
