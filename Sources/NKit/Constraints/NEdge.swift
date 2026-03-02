import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@MainActor
@frozen
public enum NEdge: Int8, Equatable, Hashable, CaseIterable, Sendable {
    case top, bottom, leading, trailing
    
    @MainActor
    @frozen
    public struct Set {
        internal let edges: [NEdge]
        
        public init(_ edges: [NEdge]) {
            self.edges = edges
        }
        
        public init(_ edges: NEdge...) {
            self.edges = edges
        }
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
    @MainActor
    @frozen
    public enum Corner: Int8, Equatable, Hashable, CaseIterable, Sendable {
        case bottomLeading
        case bottomTrailing
        case topLeading
        case topTrailing
        
        @frozen
        public struct Set {
            internal let corners: [NEdge.Corner]
            
            public init(_ corners: [NEdge.Corner]) {
                self.corners = corners
            }
        }
    }
}

extension NEdge.Corner.Set {
    public static let none: NEdge.Corner.Set           = .init([])
    public static let topLeading: NEdge.Corner.Set     = .init([.topLeading])
    public static let topTrailing: NEdge.Corner.Set    = .init([.topTrailing])
    public static let bottomLeading: NEdge.Corner.Set  = .init([.bottomLeading])
    public static let bottomTrailing: NEdge.Corner.Set = .init([.bottomTrailing])
    public static let all: NEdge.Corner.Set            = .init([.bottomLeading, .bottomTrailing, .topLeading, .topTrailing])
    public static let leading: NEdge.Corner.Set        = .init([.bottomLeading, .topLeading])
    public static let trailing: NEdge.Corner.Set       = .init([.bottomTrailing, .topTrailing])
    public static let bottom: NEdge.Corner.Set         = .init([.bottomLeading, .bottomTrailing])
    public static let top: NEdge.Corner.Set            = .init([.topLeading, .topTrailing])
}

extension NEdge {
    public func constraint(
        superview: NLayoutGuide,
        subview: NLayoutGuide,
        value: CGFloat = 0,
        symbol: NLayoutSymbol = .equal,
        priority: NLayoutPriority? = nil,
        ignoresSafeArea: Bool = false
    ) -> NSLayoutConstraint {
        let superviewLayoutGuide: NLayoutGuide = ignoresSafeArea ? superview : superview.nSafeAreaLayoutGuide
        
        switch self {
        case .top:
            return subview.topAnchor.constraint(to: superviewLayoutGuide.topAnchor, constant: value, symbol: symbol, priority: priority)
        case .bottom:
            return superviewLayoutGuide.bottomAnchor.constraint(to: subview.bottomAnchor, constant: value, symbol: symbol, priority: priority)
        case .leading:
            return subview.leadingAnchor.constraint(to: superviewLayoutGuide.leadingAnchor, constant: value, symbol: symbol, priority: priority)
        case .trailing:
            return superviewLayoutGuide.trailingAnchor.constraint(to: subview.trailingAnchor, constant: value, symbol: symbol, priority: priority)
        }
    }
}

extension NEdge.Set {
    public func constraints(
        superview: NLayoutGuide,
        subview: NLayoutGuide,
        value: CGFloat = 0,
        symbol: NLayoutSymbol = .equal,
        priority: NLayoutPriority? = nil,
        ignoresSafeArea: Bool = false
    ) -> [NSLayoutConstraint] {
        self.edges.map { edge in
            edge.constraint(superview: superview, subview: subview, value: value, symbol: symbol, priority: priority, ignoresSafeArea: ignoresSafeArea)
        }
    }
}

extension NSLayoutXAxisAnchor {
    internal func constraint(
        to anchor: NSLayoutXAxisAnchor,
        constant: CGFloat,
        symbol: NLayoutSymbol,
        priority: NLayoutPriority? = nil
    ) -> NSLayoutConstraint {
        switch symbol {
        case .equal:
            let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        case .greater:
            let constraint: NSLayoutConstraint = self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        case .less:
            let constraint: NSLayoutConstraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        }
    }
}

extension NSLayoutYAxisAnchor {
    internal func constraint(
        to anchor: NSLayoutYAxisAnchor,
        constant: CGFloat,
        symbol: NLayoutSymbol,
        priority: NLayoutPriority? = nil
    ) -> NSLayoutConstraint {
        switch symbol {
        case .equal:
            let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        case .greater:
            let constraint: NSLayoutConstraint = self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        case .less:
            let constraint: NSLayoutConstraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
            if let priority {
                constraint.layoutPriority = priority
            }
            return constraint
        }
    }
}
