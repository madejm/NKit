import Foundation
#if canImport(AppKit)
import AppKit

extension NSImage {
    public func view() -> NSView {
        let imageView = NSImageView(image: self)
        
        return imageView
    }
}
#endif
