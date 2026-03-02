import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension _View {
    public func opacity(_ opacity: Float) -> Self {
        self.opacity(NGet.constant(opacity))
    }
    
    public func opacity(_ opacity: NBinding<Float>) -> Self {
        self.opacity(opacity.get)
    }
    
    public func opacity(_ opacity: NGet<Float>) -> Self {
        self.opacity = opacity.wrappedValue
        
        opacity.onChange { [weak self] in
            self?.opacity = $0
        }
        
        return self
    }
}

#if canImport(AppKit)
extension NSView {
    @inline(__always)
    internal var opacity: Float {
        get {
            self.layer?.opacity ?? 0.0
        }
        set {
            self.layer?.opacity = newValue
        }
    }
}
#elseif canImport(UIKit)
extension UIView {
    @inline(__always)
    internal var opacity: Float {
        get {
            self.layer.opacity
        }
        set {
            self.layer.opacity = newValue
        }
    }
}
#endif
