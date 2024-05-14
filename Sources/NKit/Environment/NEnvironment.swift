import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// Example:
/// ```
/// @NEnvironment(\.foreground) private var foreground
/// ```
@propertyWrapper
public final class NEnvironment<Value: Equatable>: NOwnable {
    private var values = NEnvironmentValues()
    private var binding: NBinding<Value>!
    
    internal let keyPath: KeyPath<NEnvironmentValues, Value>
    internal unowned var owner: NOwner?
    
    public var wrappedValue: Value {
        didSet {
            self.binding.wrappedValue = wrappedValue
            self.owner?.propagateToChildren(value: wrappedValue, key: keyPath)
        }
    }
    
    public var projectedValue: NGet<Value> {
        self.binding.get
    }
    
    public init(
        _ keyPath: KeyPath<NEnvironmentValues, Value>
    ) {
        self.keyPath = keyPath
        self.wrappedValue = values[keyPath: keyPath]
        
        self.binding = .init(
            get: {
                self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
            }
        )
        
        #if canImport(AppKit)
        NSViewController.swizzleEnvIfNeeded()
        NSView.swizzleEnvIfNeeded()
        #elseif canImport(UIKit)
        UIViewController.swizzleEnvIfNeeded()
        UIView.swizzleEnvIfNeeded()
        #endif
    }
}
