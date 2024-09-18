import Foundation

@propertyWrapper
public final class NValue<Value> {
    public var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
