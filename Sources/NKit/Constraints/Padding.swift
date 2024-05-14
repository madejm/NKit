import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

internal final class NPadding: BaseView {
    internal init(
        edges: NEdge.Set,
        symbol: NEdge.Symbol,
        value: NGet<CGFloat>,
        subview: _View
        
    ) {
        super.init()
        
        self.addPaddedSubview(edges: edges, subview: subview, value: value, symbol: symbol)
    }
}

extension _View {
    public func padding(
        _ value: CGFloat
    ) -> _View {
        NPadding(edges: .all, symbol: .equal, value: .constant(value), subview: self)
    }
    
    public func padding(
        _ edges: NEdge.Set,
        _ value: CGFloat,
        symbol: NEdge.Symbol = .equal
    ) -> _View {
        NPadding(edges: edges, symbol: symbol, value: .constant(value), subview: self)
    }
    
    public func padding(
        _ value: NGet<CGFloat>
    ) -> _View {
        NPadding(edges: .all, symbol: .equal, value: value, subview: self)
    }
    
    public func padding(
        _ edges: NEdge.Set,
        _ value: NGet<CGFloat>,
        symbol: NEdge.Symbol = .equal
    ) -> _View {
        NPadding(edges: edges, symbol: symbol, value: value, subview: self)
    }
}
