import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NSLayoutConstraint {
    @inline(__always)
    @discardableResult
    public func activate() -> Self {
        self.isActive = true
        return self
    }
}

extension Array where Element == NSLayoutConstraint {
    @inline(__always)
    @discardableResult
    public func activate() -> Self {
        self.forEach {
            $0.isActive = true
        }
        return self
    }
}

extension Array where Element == NSLayoutConstraint {
    @inline(__always)
    @discardableResult
    public func deactivate() -> Self {
        self.forEach {
            $0.isActive = false
        }
        return self
    }
}

extension NSLayoutConstraint {
    public static func activate(
        @NLayoutConstraintBuilder _ constraints: () -> [NSLayoutConstraint]
    ) {
        NSLayoutConstraint.activate(constraints())
    }
    
    public static func deactivate(
        @NLayoutConstraintBuilder _ constraints: () -> [NSLayoutConstraint]
    ) {
        NSLayoutConstraint.deactivate(constraints())
    }
}

@resultBuilder
public struct NLayoutConstraintBuilder {
    public typealias Expression = NSLayoutConstraint
    public typealias Component = [NSLayoutConstraint]
    
    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap(\.self)
    }
    
    public static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }
    
    public static func buildExpression(_ expression: Component) -> Component {
        expression
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        component ?? []
    }
    
    public static func buildEither(first component: Component) -> Component {
        component
    }
    
    public static func buildEither(second component: Component) -> Component {
        component
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        components.flatMap(\.self)
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Component {
        component
    }
}
