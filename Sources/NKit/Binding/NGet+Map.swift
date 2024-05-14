import Foundation

extension NBinding {
    public var get: NGet<Value> {
        let newGetter: NGet<Value> = .init(get: {
            self.wrappedValue
        })
        
        self.onChange { newValue in
            newGetter.wrappedValue = newValue
        }
        
        return newGetter
    }
}

extension NGet {
    public func map<M>(
        up: @escaping (Value) -> M
    ) -> NGet<M> {
        let newGetter: NGet<M> = .init(get: {
            up(self.wrappedValue)
        })
        
        self.onChange { newValue in
            newGetter.wrappedValue = up(newValue)
        }
        
        return newGetter
    }
}

extension NGet {
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> NGet<T> {
        let newBinding: NGet<T> = .init(get: {
            self.wrappedValue[keyPath: keyPath]
        })
        
        self.onChange { newValue in
            let value: T = newValue[keyPath: keyPath]
            newBinding.wrappedValue = value
        }
        
        return newBinding
    }
}
