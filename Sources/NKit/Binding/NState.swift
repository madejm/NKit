import Foundation

@propertyWrapper
public final class NState<Value: Equatable> {
    private var binding: NBinding<Value>!
    
    public var wrappedValue: Value {
        didSet {
            if wrappedValue != oldValue {
                self.binding.wrappedValue = wrappedValue
            }
        }
    }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        
        self.binding = .init(get: {
            self.wrappedValue
        }, set: {
            self.wrappedValue = $0
        })
    }
    
//    public init() where Value: ExpressibleByNilLiteral {
//        self.wrappedValue = nil
//    }
    
    public var projectedValue: NBinding<Value> {
        self.binding
    }
}
