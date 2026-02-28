import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    #if canImport(AppKit)
    private final class BackgroundView: BaseView {
        fileprivate init(color: NGet<_Color>, subview: _View) {
            super.init()
            
            self.backgroundColor = color.wrappedValue
            
            color.onChange { [weak self] in
                self?.backgroundColor = $0
            }
            
            self.addSubviewAutomatically(subview)
        }
    }
    #endif
    
    public func background(_ color: _Color) -> _View {
        self.background(.constant(color))
    }
    
    public func background(_ color: NGet<_Color>) -> _View {
        #if canImport(AppKit)
        guard self.layer != nil else {
            return BackgroundView(color: color, subview: self)
        }
        #endif
        backgroundColor = color.wrappedValue
        
        color.onChange { [weak self] in
            self?.backgroundColor = $0
        }
        
        return self
    }
}

#if canImport(AppKit)
extension NSView {
    @inline(__always)
    internal var backgroundColor: NSColor? {
        get {
            self.layer?.backgroundColor.flatMap { NSColor(cgColor: $0) }
        }
        set {
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}
#endif
