import Foundation

@MainActor
public protocol NAnyGet<Value> {
    associatedtype Value: Equatable
    
    var wrappedValue: Value { get }
    
    func onChange(
        _ new: @escaping (Value) -> Void
    )
    
    var get: NGet<Value> { get }
}

extension NGet: NAnyGet {
    public var get: NGet<Value> {
        self
    }
}

extension NBinding: NAnyGet {
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

extension NState: NAnyGet {
    public func onChange(
        _ new: @escaping (Value) -> Void
    ) {
        self.projectedValue.onChange(new)
    }
    
    public var get: NGet<Value> {
        self.projectedValue.get
    }
}
