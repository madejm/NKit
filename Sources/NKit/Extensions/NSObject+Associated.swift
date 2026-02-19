import Foundation
import Combine

@MainActor
internal struct AssociatedId<Value> {
    let key: UnsafeRawPointer
    
    init(key: UnsafeRawPointer) {
        self.key = key
    }
}

internal protocol AssociatedIdDefaultable {
    static var defaultValue: Self { get }
}

extension PassthroughSubject: AssociatedIdDefaultable {
    internal static var defaultValue: PassthroughSubject<Output, Failure> {
        .init()
    }
}

extension NSObject {
    
    private final class PACK: NSObject {
        let value: Any
        
        init(_ value: Any) {
            self.value = value
        }
    }
    
    @MainActor
    private func getAssociatedValue<Value>(
        associatedId: AssociatedId<Value>
    ) -> Value? {
        let object = objc_getAssociatedObject(self, associatedId.key)
        let pack = object as? PACK
        let value = pack?.value as? Value
        return value
    }
    
    @MainActor
    private func setAssociatedValue<Value>(
        value: Value?,
        associatedId: AssociatedId<Value>
    ) {
        let pack = PACK(value as Any)
        objc_setAssociatedObject(self, associatedId.key, pack, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @MainActor
    internal subscript<Value>(
        associatedId associatedId: AssociatedId<Value>
    ) -> Value? {
        get {
            getAssociatedValue(associatedId: associatedId)
        }
        set {
            setAssociatedValue(value: newValue, associatedId: associatedId)
        }
    }
    
    @MainActor
    internal subscript<Value>(
        associatedId associatedId: AssociatedId<Value>
    ) -> Value where Value: AssociatedIdDefaultable {
        get {
            self[associatedId: associatedId, default: Value.defaultValue]
        }
        set {
            self[associatedId: associatedId, default: Value.defaultValue] = newValue
        }
    }
    
    @MainActor
    internal subscript<Value>(
        associatedId associatedId: AssociatedId<Value>,
        default defaultValue: Value
    ) -> Value {
        get {
            let value: Value? = getAssociatedValue(associatedId: associatedId)
            if let value {
                return value
            }
            self[associatedId: associatedId] = defaultValue
            return defaultValue
        }
        set {
            setAssociatedValue(value: newValue, associatedId: associatedId)
        }
    }
}
