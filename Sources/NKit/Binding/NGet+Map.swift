import Foundation
import FixedArray

extension NGet {
    public func map<M>(
        optional: @escaping @MainActor (Value) -> M?
    ) -> NGet<M> {
        let newGetter: NGet<M> = .init(get: {
            if let mappedOptional = optional(self.wrappedValue) {
                return mappedOptional
            } else {
                fatalError("Get index out of range")
            }
        })
        
        self.onChange { newValue in
            if let mappedOptional = optional(newValue) {
                newGetter.signalChange(mappedOptional)
            }
        }
        
        return newGetter
    }
    
    public func map<V, M>(
        some: @escaping @MainActor (V) -> M,
        none valueForNil: @escaping @MainActor () -> M
    ) -> NGet<M> where Value == V? {
        let newGetter: NGet<M> = .init(get: {
            if let value = self.wrappedValue {
                return some(value)
            } else {
                return valueForNil()
            }
        })
        
        self.onChange { newValue in
            if let newValue {
                newGetter.signalChange(some(newValue))
            } else {
                newGetter.signalChange(valueForNil())
            }
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
            InlineArray($0)!
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
