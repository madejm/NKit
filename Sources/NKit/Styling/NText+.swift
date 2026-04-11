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
    
    public func foregroundStyle(_ color: _Color) -> Self {
        self.textColor = color
        return self
    }
}

#if canImport(AppKit)
#elseif canImport(UIKit)
#endif
