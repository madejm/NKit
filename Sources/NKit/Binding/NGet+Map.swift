import Foundation

extension NBinding {
    public var get: NGet<Value> {
        let newGetter: NGet<Value> = .init(get: {
            self.wrappedValue
        })
        
        self.onChange { newValue in
            newGetter.signalChange(newValue)
        }
        
        return newGetter
    }
}

extension NGet {
    public func map<M>(
        up: @escaping @MainActor (Value) -> M
    ) -> NGet<M> {
        let newGetter: NGet<M> = .init(get: {
            up(self.wrappedValue)
        })
        
        self.onChange { newValue in
            newGetter.signalChange(up(newValue))
        }
        
        return newGetter
    }
}

extension NGet {
    public func map() -> NGet<Value?> {
        self.map(up: {
            $0
        })
    }
    
    public func map() -> NGet<String> where Value == String? {
        self.map(up: {
            $0 ?? ""
        })
    }
    
    public func map() -> NGet<String> where Value == Int {
        self.map(up: {
            String($0)
        })
    }
    
    public func map() -> NGet<Int> where Value == String {
        self.map(up: {
            Int($0) ?? 0
        })
    }
}

extension NGet {
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> NGet<T> {
        let newBinding: NGet<T> = .init(get: {
            self.wrappedValue[keyPath: keyPath]
        })
        
        self.onChange { newValue in
            let value: T = newValue[keyPath: keyPath]
            newBinding.signalChange(value)
        }
        
        return newBinding
    }
}
