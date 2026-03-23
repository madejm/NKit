import Foundation

extension NGet {
    public static func combine(
        _ v1: any NAnyGet<Bool>,
        _ v2: any NAnyGet<Bool>
    ) -> NGet<Bool> {
        .combine(v1, v2) {
            $0 && $1
        }
    }
    
    public static func combine<V1, V2>(
        _ v1: any NAnyGet<V1>,
        _ v2: any NAnyGet<V2>,
        operation: @escaping @MainActor (V1, V2) -> Value
    ) -> NGet<Value> {
        let newGet: NGet<Value> = .init(get: {
            operation(v1.wrappedValue, v2.wrappedValue)
        })
        
        v1.onChange { newValue in
            newGet.signalChange(operation(newValue, v2.wrappedValue))
        }
        v2.onChange { newValue in
            newGet.signalChange(operation(v1.wrappedValue, newValue))
        }
        
        return newGet
    }
    
    public static func combine3<V1, V2, V3>(
        _ v1: any NAnyGet<V1>,
        _ v2: any NAnyGet<V2>,
        _ v3: any NAnyGet<V3>,
        operation: @escaping @MainActor (V1, V2, V3) -> Value
    ) -> NGet<Value> {
        let newGet: NGet<Value> = .init(get: {
            operation(v1.wrappedValue, v2.wrappedValue, v3.wrappedValue)
        })
        
        v1.onChange { newValue in
            newGet.signalChange(operation(newValue, v2.wrappedValue, v3.wrappedValue))
        }
        v2.onChange { newValue in
            newGet.signalChange(operation(v1.wrappedValue, newValue, v3.wrappedValue))
        }
        v3.onChange { newValue in
            newGet.signalChange(operation(v1.wrappedValue, v2.wrappedValue, newValue))
        }
        
        return newGet
    }
    
    public static func combine4<V1, V2, V3, V4>(
        _ v1: any NAnyGet<V1>,
        _ v2: any NAnyGet<V2>,
        _ v3: any NAnyGet<V3>,
        _ v4: any NAnyGet<V4>,
        operation: @escaping @MainActor (V1, V2, V3, V4) -> Value
    ) -> NGet<Value> {
        let newGet: NGet<Value> = .init(get: {
            operation(v1.wrappedValue, v2.wrappedValue, v3.wrappedValue, v4.wrappedValue)
        })
        
        v1.onChange { newValue in
            newGet.signalChange(operation(newValue, v2.wrappedValue, v3.wrappedValue, v4.wrappedValue))
        }
        v2.onChange { newValue in
            newGet.signalChange(operation(v1.wrappedValue, newValue, v3.wrappedValue, v4.wrappedValue))
        }
        v3.onChange { newValue in
            newGet.signalChange(operation(v1.wrappedValue, v2.wrappedValue, newValue, v4.wrappedValue))
        }
        v4.onChange { newValue in
            newGet.signalChange(operation(v1.wrappedValue, v2.wrappedValue, v3.wrappedValue, newValue))
        }
        
        return newGet
    }
}
