import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@MainActor
@frozen
public enum NDimmension: Equatable {
    case width, height
    
    @frozen
    public struct Set {
        internal let dimmensions: [NDimmension]
        
        public init(_ dimmensions: [NDimmension]) {
            self.dimmensions = dimmensions
        }
    }
    
    @frozen
    public enum Symbol {
        case equal
        case greater
        case less
    }
}

extension NDimmension {
    internal func constraint(
        view: _View,
        value: CGFloat = 0,
        symbol: NDimmension.Symbol = .equal,
        priority: LayoutPriority? = nil
    ) -> NSLayoutConstraint {
        switch self {
        case .width:
            return view.widthAnchor.constraint(constant: value, symbol: symbol, priority: priority)
        case .height:
            return view.heightAnchor.constraint(constant: value, symbol: symbol, priority: priority)
        }
    }
    
    internal func constraint(
        superview: _View,
        subview: _View,
        multiplier: CGFloat = 1,
        value: CGFloat = 0,
        symbol: NDimmension.Symbol = .equal,
        priority: LayoutPriority? = nil
    ) -> NSLayoutConstraint {
        switch self {
        case .width:
            return subview.widthAnchor.constraint(to: superview.widthAnchor, multiplier: multiplier, constant: value, symbol: symbol, priority: priority)
        case .height:
            return superview.heightAnchor.constraint(to: subview.heightAnchor, multiplier: multiplier, constant: value, symbol: symbol, priority: priority)
        }
    }
}

extension NSLayoutDimension {
    internal func constraint(
        constant: CGFloat,
        symbol: NDimmension.Symbol,
        priority: LayoutPriority? = nil
    ) -> NSLayoutConstraint {
        switch symbol {
        case .equal:
            let constraint: NSLayoutConstraint = self.constraint(equalToConstant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        case .greater:
            let constraint: NSLayoutConstraint = self.constraint(greaterThanOrEqualToConstant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        case .less:
            let constraint: NSLayoutConstraint = self.constraint(lessThanOrEqualToConstant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        }
    }
    
    internal func constraint(
        to anchor: NSLayoutDimension,
        multiplier: CGFloat,
        constant: CGFloat,
        symbol: NDimmension.Symbol,
        priority: LayoutPriority? = nil
    ) -> NSLayoutConstraint {
        switch symbol {
        case .equal:
            let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        case .greater:
            let constraint: NSLayoutConstraint = self.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        case .less:
            let constraint: NSLayoutConstraint = self.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        }
    }
}
