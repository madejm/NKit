import Foundation

extension NBinding {
    public func map<M>(
        up: @escaping (Value) -> M,
        down: @escaping (M) -> Value
    ) -> NBinding<M> {
        let newBinding: NBinding<M> = .init(get: {
            up(self.wrappedValue)
        }, set: {
            self.wrappedValue = down($0)
        })
        
        self.onChange { newValue in
            newBinding.wrappedValue = up(newValue)
        }
        newBinding.onChange { [weak self] newValue in
            self?.wrappedValue = down(newValue)
        }
        
        return newBinding
    }
    
    public func map<M>(
        up: @escaping (Value) -> M
    ) -> NBinding<M> where Value == Optional<M> {
        self.map(up: up, down: {
            $0
        })
    }
    
    public func map(
        down: @escaping (Value?) -> Value
    ) -> NBinding<Value?> {
        self.map(up: {
            $0
        }, down: down)
    }
}

extension NBinding {
    public func map() -> NBinding<String?> where Value == String {
        self.map(down: {
            $0 ?? ""
        })
    }
    
    public func map() -> NBinding<String> where Value == String? {
        self.map(up: {
            $0 ?? ""
        })
    }
    
    public func map() -> NBinding<String> where Value == Int {
        self.map(up: {
            String($0)
        }, down: {
            Int($0) ?? 0
        })
    }
    
    public func map() -> NBinding<Int> where Value == String {
        self.map(up: {
            Int($0) ?? 0
        }, down: {
            String($0)
        })
    }
}

extension NBinding {
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> NBinding<T> {
        let newBinding: NBinding<T> = .init(get: {
            self.wrappedValue[keyPath: keyPath]
        }, set: { _ in
        })
        
        self.onChange { newValue in
            let value: T = newValue[keyPath: keyPath]
            newBinding.wrappedValue = value
        }
        
        return newBinding
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> NBinding<T> {
        let newBinding: NBinding<T> = .init(get: {
            self.wrappedValue[keyPath: keyPath]
        }, set: {
            var copy = self.wrappedValue
            copy[keyPath: keyPath] = $0
            self.wrappedValue = copy
        })
        
        self.onChange { newValue in
            let value: T = newValue[keyPath: keyPath]
            newBinding.wrappedValue = value
        }
        newBinding.onChange { [weak self] newValue in
            guard let self = self else {
                return
            }
            
            var copy = self.wrappedValue
            copy[keyPath: keyPath] = newValue
            self.wrappedValue = copy
        }
        
        return newBinding
    }
}

extension NBinding where Value == Bool {
    public static prefix func !(original: NBinding<Value>) -> NBinding<Value> {
        return original.map(
            up: {
                !$0
            },
            down: {
                !$0
            }
        )
    }
}

extension NGet where Value == Bool {
    public static prefix func !(original: NGet<Value>) -> NGet<Value> {
        return original.map(
            up: {
                !$0
            }
        )
    }
}
