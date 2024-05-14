import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    public func frame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        symbol: NEdge.Symbol = .equal
    ) -> _View {
        self.frame(
            width: width.map { .constant($0) },
            height: height.map { .constant($0) },
            symbol: symbol
        )
    }
    
    public func frame(
        width: NGet<CGFloat>? = nil,
        height: NGet<CGFloat>? = nil,
        symbol: NEdge.Symbol = .equal
    ) -> _View {
        if let width = width {
            let constraint = self.widthAnchor.constraint(constant: width.wrappedValue, symbol: symbol)
            
            width.onChange {
                constraint.constant = $0
            }
            
            constraint.isActive = true
        }
        if let height = height {
            let constraint = self.heightAnchor.constraint(constant: height.wrappedValue, symbol: symbol)
            
            height.onChange {
                constraint.constant = $0
            }
            
            constraint.isActive = true
        }
        
        return self
    }
}
