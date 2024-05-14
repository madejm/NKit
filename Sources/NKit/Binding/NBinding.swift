import Foundation
import Combine

@propertyWrapper @dynamicMemberLookup
public final class NBinding<Value: Equatable> {
    private let getClosure: () -> Value
    private let setClosure: ((Value) -> Void)
    
    private var cancellables = Set<AnyCancellable>()
    private var onSets: [PassthroughSubject<Value, Never>] = []
    
    public var wrappedValue: Value {
        get {
            self.getClosure()
        }
        set {
            let oldValue = wrappedValue
            
            if oldValue != newValue {
                self.setClosure(newValue)
            }
            
            self.onSets.forEach { subject in
                subject.send(newValue)
            }
        }
    }
    
    public var projectedValue: NBinding<Value> {
        self
    }
    
    public init(
        get: @escaping () -> Value,
        set: @escaping (Value) -> Void
    ) {
        self.getClosure = get
        self.setClosure = set
    }
    
    public func onChange(_ new: @escaping (Value) -> Void) {
        let subject = PassthroughSubject<Value, Never>()
        
        subject
            .removeDuplicates()
            .sink { newValue in
                new(newValue)
            }
            .store(in: &cancellables)
        
        onSets.append(subject)
    }
}

extension NBinding {
    public static func constant(_ value: Value) -> NBinding<Value> {
        .init(get: { value }, set: { _ in })
    }
}
