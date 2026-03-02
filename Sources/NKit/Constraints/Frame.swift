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
        symbol: NLayoutSymbol = .equal
    ) -> Self {
        self.frame(
            width: width.map { .constant($0) },
            height: height.map { .constant($0) },
            symbol: symbol
        )
    }
    
    public func frame(
        width: NGet<CGFloat>? = nil,
        height: NGet<CGFloat>? = nil,
        symbol: NLayoutSymbol = .equal
    ) -> Self {
        if let width {
            let constraint = self.widthAnchor.constraint(constant: width.wrappedValue, symbol: symbol)
            
            width.onChange { [weak self] in
                constraint.constant = $0
                self?.layoutIfNeeded()
            }
            
            constraint.isActive = true
        }
        if let height {
            let constraint = self.heightAnchor.constraint(constant: height.wrappedValue, symbol: symbol)
            
            height.onChange { [weak self] in
                constraint.constant = $0
                self?.layoutIfNeeded()
            }
            
            constraint.isActive = true
        }
        
        return self
    }
    
    public func frame(
        minWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        maxHeight: CGFloat? = nil
    ) -> Self {
        self.frame(
            minWidth: minWidth.map { .constant($0) },
            minHeight: minHeight.map { .constant($0) },
            maxWidth: maxWidth.map { .constant($0) },
            maxHeight: maxHeight.map { .constant($0) }
        )
    }
    
    public func frame(
        minWidth: NGet<CGFloat>? = nil,
        minHeight: NGet<CGFloat>? = nil,
        maxWidth: NGet<CGFloat>? = nil,
        maxHeight: NGet<CGFloat>? = nil
    ) -> Self {
        if let minWidth {
            let constraint = self.widthAnchor.constraint(constant: minWidth.wrappedValue, symbol: .greater)
            
            minWidth.onChange { [weak self] in
                constraint.constant = $0
                self?.layoutIfNeeded()
            }
            
            constraint.isActive = true
        }
        if let minHeight {
            let constraint = self.heightAnchor.constraint(constant: minHeight.wrappedValue, symbol: .greater)
            
            minHeight.onChange { [weak self] in
                constraint.constant = $0
                self?.layoutIfNeeded()
            }
            
            constraint.isActive = true
        }
        if let maxWidth {
            let constraint = self.widthAnchor.constraint(constant: maxWidth.wrappedValue, symbol: .less)
            
            maxWidth.onChange { [weak self] in
                constraint.constant = $0
                self?.layoutIfNeeded()
            }
            
            constraint.isActive = true
        }
        if let maxHeight {
            let constraint = self.heightAnchor.constraint(constant: maxHeight.wrappedValue, symbol: .less)
            
            maxHeight.onChange { [weak self] in
                constraint.constant = $0
                self?.layoutIfNeeded()
            }
            
            constraint.isActive = true
        }
        
        return self
    }
}
