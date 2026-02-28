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
}

extension NDimmension {
    public func constraint(
        view: _View,
        value: CGFloat = 0,
        symbol: NLayoutSymbol = .equal,
        priority: NLayoutPriority? = nil,
        ignoresSafeArea: Bool = false
    ) -> NSLayoutConstraint {
        let layoutGuide: NLayoutGuide = ignoresSafeArea ? view : view.nSafeAreaLayoutGuide
        
        switch self {
        case .width:
            return layoutGuide.widthAnchor.constraint(constant: value, symbol: symbol, priority: priority)
        case .height:
            return layoutGuide.heightAnchor.constraint(constant: value, symbol: symbol, priority: priority)
        }
    }
    
    public func constraint(
        superview: _View,
        subview: _View,
        multiplier: CGFloat = 1,
        value: CGFloat = 0,
        symbol: NLayoutSymbol = .equal,
        priority: NLayoutPriority? = nil,
        ignoresSafeArea: Bool = false
    ) -> NSLayoutConstraint {
        let superviewLayoutGuide: NLayoutGuide = ignoresSafeArea ? superview : superview.nSafeAreaLayoutGuide
        
        switch self {
        case .width:
            return superviewLayoutGuide.widthAnchor.constraint(to: subview.widthAnchor, multiplier: multiplier, constant: value, symbol: symbol, priority: priority)
        case .height:
            return superviewLayoutGuide.heightAnchor.constraint(to: subview.heightAnchor, multiplier: multiplier, constant: value, symbol: symbol, priority: priority)
        }
    }
}

extension NSLayoutDimension {
    internal func constraint(
        constant: CGFloat,
        symbol: NLayoutSymbol,
        priority: NLayoutPriority? = nil
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
        symbol: NLayoutSymbol,
        priority: NLayoutPriority? = nil
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
