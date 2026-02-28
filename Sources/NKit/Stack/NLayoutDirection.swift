import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// Describes direction of views in stack.
public enum NLayoutDirection {
    case vertical
    case horizontal
}

/// Implement this protocol to inform a `NSView`/`UIView` about it's direction in stack.
/// For example `NDivider` implements this protocol to size itself in the stack.
@MainActor
public protocol NLayoutDirectionable {
    func didChangeLayoutDirection(_ layoutDirection: NLayoutDirection)
}

extension AssociatedId where Value == NLayoutDirection {
    fileprivate static let layoutDirection: Self = .init(key: "layoutDirection")
}

extension _View {
    /// Current layout direction in stack.
    /// `nil` if view has not been placed in a stack.
    public var layoutDirection: NLayoutDirection? {
        get {
            self[associatedId: .layoutDirection]
        }
        set {
            self[associatedId: .layoutDirection] = newValue
        }
    }
    
    internal func setLayoutDirection(_ layoutDirection: NLayoutDirection) {
        if self is _Stack {
            return
        }
        guard self.layoutDirection != layoutDirection else {
            return
        }
        self.layoutDirection = layoutDirection
        
        for view in subviews {
            view.setLayoutDirection(layoutDirection)
        }
        
        if let directionable = self as? NLayoutDirectionable {
            directionable.didChangeLayoutDirection(layoutDirection)
        }
    }
}
