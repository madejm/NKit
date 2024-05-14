import Foundation

extension NBinding {
    public static func combine(
        _ one: NBinding<Value>,
        _ two: NBinding<Value>
    ) -> NBinding<Value> where Value == Bool {
        .combine(one, two) {
            $0 && $1
        }
    }
    
    public static func combine(
        _ one: NBinding<Value>,
        _ two: NBinding<Value>,
        operation: @escaping (Value, Value) -> Value
    ) -> NBinding<Value> {
        let newBinding: NBinding<Value> = .init(get: {
            operation(one.wrappedValue, two.wrappedValue)
        }, set: {
            one.wrappedValue = $0
            two.wrappedValue = $0
        })
        
        one.onChange { newValue in
            newBinding.wrappedValue = operation(two.wrappedValue, newValue)
        }
        two.onChange { newValue in
            newBinding.wrappedValue = operation(one.wrappedValue, newValue)
        }
        
        return newBinding
    }
}
