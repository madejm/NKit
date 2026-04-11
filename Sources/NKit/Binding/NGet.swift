import Foundation
import Combine

@MainActor
@propertyWrapper @dynamicMemberLookup
public final class NGet<Value: Equatable> {
    private let getClosure: () -> Value
    
    private var cancellables = Set<AnyCancellable>()
    private let onSet = PassthroughSubject<Value, Never>()
    
    public var wrappedValue: Value {
        self.getClosure()
    }
    
    public var projectedValue: NGet<Value> {
        self
    }
    
    public init(
        get: @escaping @MainActor () -> Value
    ) {
        self.getClosure = get
    }
    
    internal func signalChange(_ newValue: Value) {
        self.onSet.send(newValue)
    }
    
    public var publisher: AnyPublisher<Value, Never> {
        onSet
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public func onChange(
        _ new: @escaping (Value) -> Void
    ) {
        onSet
            .removeDuplicates()
            .sink { newValue in
                new(newValue)
            }
            .store(in: &cancellables)
    }
}

extension NGet {
    public static func constant(_ value: Value) -> NGet<Value> {
        .init(get: { value })
    }
}

