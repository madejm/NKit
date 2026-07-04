import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NText {
    public func font(_ font: _Font) -> Self {
        self.font = font
        return self
    }
    
    public func font(_ font: NGet<_Font>) -> Self {
        self.font = font.wrappedValue
        
        font.onChange { [weak self] in
            self?.font = $0
        }
        return self
    }
    
    public func foregroundStyle(_ color: _Color) -> Self {
        self.textColor = color
        return self
    }
    
    public func foregroundStyle(_ color: NGet<_Color>) -> Self {
        self.textColor = color.wrappedValue
        
        color.onChange { [weak self] in
            self?.textColor = $0
        }
        return self
    }
}

#if canImport(AppKit)
#elseif canImport(UIKit)
#endif
