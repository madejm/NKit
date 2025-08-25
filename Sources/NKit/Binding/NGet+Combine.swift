import Foundation

extension NGet {
    public static func combine(
        _ one: any NAnyGet<Bool>,
        _ two: any NAnyGet<Bool>
    ) -> NGet<Bool> {
        .combine(one, two) {
            $0 && $1
        }
    }
    
    public static func combine<T>(
        _ one: any NAnyGet<T>,
        _ two: any NAnyGet<T>,
        operation: @escaping @MainActor (T, T) -> Value
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
