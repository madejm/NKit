import Foundation
#if canImport(AppKit)
import AppKit

extension NSColor {
    public func view() -> NSView {
        BaseView().apply {
            $0.layer?.backgroundColor = self.cgColor
        }
    }
}

extension NSView {
    private final class BackgroundView: BaseView {
        fileprivate init(color: NSColor, subview: NSView) {
            super.init()
            
            self.layer?.backgroundColor = color.cgColor
            
            self.addSubviewAutomatically(subview)
        }
    }
    
    public func background(_ color: NSColor) -> NSView {
        guard let layer = self.layer else {
            return BackgroundView(color: color, subview: self)
        }
        
        layer.backgroundColor = color.cgColor
        
        return self
    }
}
#endif
