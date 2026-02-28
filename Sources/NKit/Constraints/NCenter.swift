import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@MainActor
@frozen
public enum NCenter: Equatable {
    case x, y
    
    @frozen
    public struct Set {
        internal let dimmensions: [NCenter]
        
        public init(_ dimmensions: [NCenter]) {
            self.dimmensions = dimmensions
        }
    }
}

extension NCenter {
    public func constraint(
        superview: _View,
        subview: _View,
        value: CGFloat = 0,
        symbol: NLayoutSymbol = .equal,
        priority: NLayoutPriority? = nil,
        ignoresSafeArea: Bool = false
    ) -> NSLayoutConstraint {
        let superviewLayoutGuide: NLayoutGuide = ignoresSafeArea ? superview : superview.nSafeAreaLayoutGuide
        
        switch self {
        case .x:
            return superviewLayoutGuide.centerXAnchor.constraint(to: subview.centerXAnchor, constant: value, symbol: symbol, priority: priority)
        case .y:
            return superviewLayoutGuide.centerYAnchor.constraint(to: subview.centerYAnchor, constant: value, symbol: symbol, priority: priority)
        }
    }
}
