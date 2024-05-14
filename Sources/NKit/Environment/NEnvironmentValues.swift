import Foundation

/// Example:
/// ```
/// internal struct ForegroundEnvironmentKey: NEnvironmentKey {
///     internal static let defaultValue: NSColor = .red
/// }
/// ```
public protocol NEnvironmentKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}

/// Example:
/// ```
/// extension NEnvironmentValues {
///     internal var foreground: NSColor {
///         get { self[ForegroundEnvironmentKey.self] }
///         set { self[ForegroundEnvironmentKey.self] = newValue }
///     }
/// }
/// ```
public struct NEnvironmentValues {
    private var values: [AnyHashable: Any] = [:]
    
    public subscript<K>(key: K.Type) -> K.Value where K: NEnvironmentKey {
        get {
            let anyKey: AnyHashable = .init(String(describing: key))
            
            guard let someValue: Any = self.values[anyKey] else {
                return K.defaultValue
            }
            
            return someValue as! K.Value
        }
        set {
            let anyKey: AnyHashable = .init(String(describing: key))
            self.values[anyKey] = newValue
        }
    }
}
