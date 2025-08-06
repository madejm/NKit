import Foundation

@MainActor
public protocol NAnyGet<Value> {
    associatedtype Value: Equatable
    
    var wrappedValue: Value { get }
    
    func onChange(
        _ new: @escaping (Value) -> Void
    )
}

extension NGet: NAnyGet {}
extension NBinding: NAnyGet {}

extension NState: NAnyGet {
    public func onChange(
        _ new: @escaping (Value) -> Void
    ) {
        self.projectedValue.onChange(new)
    }
}
