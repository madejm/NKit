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
    
    public func map<V, M>(
        optional: @escaping @MainActor (V) -> M,
        nil valueForNil: @escaping @MainActor () -> M
    ) -> NGet<M> where Value == V? {
        let newGetter: NGet<M> = .init(get: {
            if let value = self.wrappedValue {
                return optional(value)
            } else {
                return valueForNil()
            }
        })
        
        self.onChange { newValue in
            if let newValue {
                newGetter.signalChange(optional(newValue))
            } else {
                newGetter.signalChange(valueForNil())
            }
        }
        
        return newGetter
    }
    
    public func map<M>(
        nil valueForNil: @escaping @MainActor () -> M
    ) -> NGet<M> where Value == M? {
        self.map(
            optional: { (value: M) -> M in
                value
            },
            nil: {
                valueForNil()
            }
        )
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

#if swift(>=6.2)
@available(macOS 26.0, iOS 26.0, *)
extension NGet {
    public func map<let count: Int, Element>() -> NGet<[Element]>
    where Value == InlineArray<count, Element> {
        self.map(up: {
            Array($0)
        })
    }
    
    public func map<let count: Int, Element>() -> NGet<InlineArray<count, Element>>
    where Value == [Element] {
        self.map(up: {
            InlineArray($0)
        })
    }
}
#endif

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
    
    @_disfavoredOverload
    public subscript<V, T>(dynamicMember keyPath: KeyPath<V, T>) -> NGet<T?>
    where Value == V? {
        let newBinding: NGet<T?> = .init(get: {
            self.wrappedValue?[keyPath: keyPath]
        })
        
        self.onChange { newValue in
            let value: T? = newValue?[keyPath: keyPath]
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
