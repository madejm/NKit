import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    public func addSubviewAutomatically(_ subview: _View) {
        self.addPaddedSubview(edges: .none, subview: subview)
    }
    
    internal func addPaddedSubview(
        edges: NEdge.Set,
        subview: _View,
        value: NGet<CGFloat> = .constant(0),
        symbol: NEdge.Symbol = .equal
    ) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        edges.edges.forEach {
            let constraint = $0.constraint(superview: self, subview: subview, value: value.wrappedValue, symbol: symbol)
            
            value.onChange {
                constraint.constant = $0
            }
            
            constraint.isActive = true
        }
        edges.rest.edges.forEach {
            $0.constraint(superview: self, subview: subview, value: 0, symbol: .equal).isActive = true
        }
    }
}
