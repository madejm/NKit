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
    @_disfavoredOverload
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
    
    public subscript<T>(_ index: Value.Index) -> NGet<T> where Value: RandomAccessCollection, Value.Element == T {
        let newBinding: NGet<T> = .init(get: {
            let unwrapped: Value = self.wrappedValue
            
            guard index < unwrapped.endIndex else {
                fatalError("index beyound bounds \(unwrapped.startIndex..<unwrapped.endIndex)")
            }
            return unwrapped[index]
        })
        
        self.onChange { newValue in
            guard index < newValue.endIndex else {
                return
            }
            let value: T = newValue[index]
            newBinding.signalChange(value)
        }
        
        return newBinding
    }
    
    public subscript<T>(_ index: Value.Index) -> NGet<T?> where Value: RandomAccessCollection, Value.Element == T {
        let newBinding: NGet<T?> = .init(get: {
            let unwrapped: Value = self.wrappedValue
            
            guard index < unwrapped.endIndex else {
                return nil
            }
            return unwrapped[index]
        })
        
        self.onChange { newValue in
            guard index < newValue.endIndex else {
                newBinding.signalChange(nil)
                return
            }
            let value: T = newValue[index]
            newBinding.signalChange(value)
        }
        
        return newBinding
    }
}
