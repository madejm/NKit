import Foundation

internal protocol NOwner: AnyObject {}

internal protocol NOwnable: AnyObject {
    var owner: NOwner? { get set }
}

extension NOwner {
    internal func setEnvironment<V: Equatable>(
        value: V,
        key: KeyPath<NEnvironmentValues, V>
    ) -> Bool {
        guard let envValue: NEnvironment<V> = self.environment(key: key) else {
            return false
        }
        
        envValue.wrappedValue = value
        
        return true
    }
    
    internal func ownables() -> [NOwnable] {
        let mirror = Mirror(reflecting: self)
        
        return mirror
            .children
            .compactMap { child in
                guard String(describing: child.value).hasPrefix("SwiftUIKit.NEnvironment") else {
                    return nil
                }
                guard let ownable: NOwnable = child.value as? NOwnable else {
                    return nil
                }
                return ownable
            }
    }
    
    private func environment<T>(
        key: KeyPath<NEnvironmentValues, T>
    ) -> NEnvironment<T>? {
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            guard String(describing: child.value).hasPrefix("SwiftUIKit.NEnvironment") else {
                continue
            }
            guard let value: NEnvironment<T> = child.value as? NEnvironment<T> else {
                continue
            }
            guard value.keyPath == key else {
                continue
            }
            return value
        }
        
        return nil
    }
}
