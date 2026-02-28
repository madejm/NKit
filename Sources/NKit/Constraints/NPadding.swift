import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

internal final class NPadding: BaseView {
    internal init(
        edges: NEdge.Set,
        symbol: NLayoutSymbol,
        value: NGet<CGFloat>,
        subview: _View
        
    ) {
        super.init()
        
        self.addPaddedSubview(edges: edges, value: value, symbol: symbol, subview: subview)
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
        symbol: NLayoutSymbol = .equal
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
        symbol: NLayoutSymbol = .equal
    ) -> _View {
        NPadding(edges: edges, symbol: symbol, value: value, subview: self)
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    NViewPreview {
        NVStack {
            NColor(.red)
                .frame(width: 100, height: 100)
                .padding(10)
                .background(.green)
            
            NColor(.red)
                .frame(width: 100, height: 100)
                .padding(20)
                .background(.green)
        }
    }
}
#endif
