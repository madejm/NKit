import Foundation

@propertyWrapper
public final class NValue<Value> {
    public var wrappedValue: Value
    
    public var projectedValue: NValue<Value> { self }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension NValue where Value: Equatable {
    @MainActor
    public var get: NGet<Value> {
        .init(
            get: {
                self.wrappedValue
            }
        )
    }
    
    @MainActor
    public var binding: NBinding<Value> {
        .init(
            get: {
                self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
            }
        )
    }
}
