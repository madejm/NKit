import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@frozen
public enum NEdge: Equatable {
    case top, bottom, leading, trailing
    
    @frozen
    public struct Set {
        internal let edges: [NEdge]
        
        public init(_ edges: [NEdge]) {
            self.edges = edges
        }
    }
    
    @frozen
    public enum Symbol {
        case equal
        case greater
        case less
    }
}

extension NEdge.Set {
    internal static let none: NEdge.Set      = .init([])
    public static let all: NEdge.Set         = .init([.top, .bottom, .leading, .trailing])
    public static let top: NEdge.Set         = .init([.top])
    public static let bottom: NEdge.Set      = .init([.bottom])
    public static let leading: NEdge.Set     = .init([.leading])
    public static let trailing: NEdge.Set    = .init([.trailing])
    public static let horizontal: NEdge.Set  = .init([.leading, .trailing])
    public static let vertical: NEdge.Set    = .init([.top, .bottom])
    
    internal var rest: NEdge.Set {
        .init(Self.all.edges.filter {
            !self.edges.contains($0)
        })
    }
}

extension NEdge {
    internal func constraint(
        superview: _View,
        subview: _View,
        value: CGFloat = 0,
        symbol: NEdge.Symbol = .equal
    ) -> NSLayoutConstraint {
        switch self {
        case .top:
            return subview.topAnchor.constraint(to: superview.topAnchor, constant: value, symbol: symbol)
        case .bottom:
            return superview.bottomAnchor.constraint(to: subview.bottomAnchor, constant: value, symbol: symbol)
        case .leading:
            return subview.leadingAnchor.constraint(to: superview.leadingAnchor, constant: value, symbol: symbol)
        case .trailing:
            return superview.trailingAnchor.constraint(to: subview.trailingAnchor, constant: value, symbol: symbol)
        }
    }
}

extension NSLayoutXAxisAnchor {
    internal func constraint(
        to anchor: NSLayoutXAxisAnchor,
        constant: CGFloat,
        symbol: NEdge.Symbol
    ) -> NSLayoutConstraint {
        switch symbol {
        case .equal:
            return self.constraint(equalTo: anchor, constant: constant)
        case .greater:
            return self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        case .less:
            return self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        }
    }
}

extension NSLayoutYAxisAnchor {
    internal func constraint(
        to anchor: NSLayoutYAxisAnchor,
        constant: CGFloat,
        symbol: NEdge.Symbol
    ) -> NSLayoutConstraint {
        switch symbol {
        case .equal:
            return self.constraint(equalTo: anchor, constant: constant)
        case .greater:
            return self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        case .less:
            return self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        }
    }
}

extension NSLayoutDimension {
    internal func constraint(
        constant: CGFloat,
        symbol: NEdge.Symbol
    ) -> NSLayoutConstraint {
        switch symbol {
        case .equal:
            return self.constraint(equalToConstant: constant)
        case .greater:
            return self.constraint(greaterThanOrEqualToConstant: constant)
        case .less:
            return self.constraint(lessThanOrEqualToConstant: constant)
        }
    }
}
