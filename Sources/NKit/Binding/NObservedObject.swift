import Foundation
import Combine

@MainActor
@propertyWrapper
@dynamicMemberLookup
public final class NObservedObject<Value: NObservableObject> {
    
    public private(set) var wrappedValue: Value
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    public var projectedValue: NObservedObject<Value> {
        self
    }
}

extension NObservedObject {
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> NGet<T> where T: Equatable {
        let newBinding: NGet<T> = .init(get: {
            self.wrappedValue[keyPath: keyPath]
        })
        
        wrappedValue.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                let value: T = wrappedValue[keyPath: keyPath]
                newBinding.signalChange(value)
            }
            .store(in: &cancellables)
        
        return newBinding
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> NBinding<T> where T: Equatable  {
        let newBinding: NBinding<T> = .init(get: {
            self.wrappedValue[keyPath: keyPath]
        }, set: {
            self.wrappedValue[keyPath: keyPath] = $0
        })
        
        wrappedValue.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                let value: T = wrappedValue[keyPath: keyPath]
                newBinding.signalChange(value)
            }
            .store(in: &cancellables)
        
        newBinding.onChange { [weak self] newValue in
            guard let self = self else {
                return
            }
            guard self.wrappedValue[keyPath: keyPath] != newValue else {
                return
            }
            self.wrappedValue[keyPath: keyPath] = newValue
        }
        
        return newBinding
    }
}

@propertyWrapper
public struct NPublished<Value: Equatable> {
    
    public var wrappedValue: Value
    
    public var projectedValue: NPublished { self }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    public static subscript<EnclosingType: NObservableObject>(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, NPublished>
    ) -> Value {
        get {
            instance[keyPath: storageKeyPath].wrappedValue
        }
        set {
            instance[keyPath: storageKeyPath].wrappedValue = newValue
            instance.objectWillChange.send()
        }
    }
}

private final class _WeakObservedObject {
    weak var object: (any NObservableObject)?
    let publisher: PassthroughSubject<Void, Never> = .init()
}

nonisolated(unsafe) private var _observedObjects: [_WeakObservedObject] = []

public protocol NObservableObject: AnyObject/*, Equatable*/ {
    var objectWillChange: PassthroughSubject<Void, Never> { get }
}

extension NObservableObject {
    public var objectWillChange: PassthroughSubject<Void, Never> {
        _observedObjects.removeAll(where: { $0.object == nil })
        
        if let object: _WeakObservedObject = _observedObjects.first(where: { $0.object === self }) {
            return object.publisher
        }
        
        let object = _WeakObservedObject()
        object.object = self
        _observedObjects.append(object)
        return object.publisher
    }
}
