import Foundation

@propertyWrapper
public final class NValue<Value> {
    public var wrappedValue: Value
    
    public var projectedValue: NValue<Value> { self }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
