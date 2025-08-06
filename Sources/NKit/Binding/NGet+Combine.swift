import Foundation

extension NGet {
    public static func combine(
        _ one: any NAnyGet<Value>,
        _ two: any NAnyGet<Value>
    ) -> NGet<Value> where Value == Bool {
        .combine(one, two) {
            $0 && $1
        }
    }
    
    public static func combine(
        _ one: any NAnyGet<Value>,
        _ two: any NAnyGet<Value>,
        operation: @escaping @MainActor (Value, Value) -> Value
    ) -> NGet<Value> {
        let newGet: NGet<Value> = .init(get: {
            operation(one.wrappedValue, two.wrappedValue)
        })
        
        one.onChange { newValue in
            newGet.signalChange(operation(newValue, two.wrappedValue))
        }
        two.onChange { newValue in
            newGet.signalChange(operation(one.wrappedValue, newValue))
        }
        
        return newGet
    }
}
