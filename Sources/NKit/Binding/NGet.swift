import Foundation
import Combine

@propertyWrapper @dynamicMemberLookup
public final class NGet<Value: Equatable> {
    private let getClosure: () -> Value
    
    private var cancellables = Set<AnyCancellable>()
    private var onSets: [PassthroughSubject<Value, Never>] = []
    
    public var wrappedValue: Value {
        get {
            self.getClosure()
        }
        set {
            self.onSets.forEach { subject in
                subject.send(newValue)
            }
        }
    }
    
    public var projectedValue: NGet<Value> {
        self
    }
    
    public init(
        get: @escaping () -> Value
    ) {
        self.getClosure = get
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

extension NGet {
    public static func constant(_ value: Value) -> NGet<Value> {
        .init(get: { value })
    }
}

