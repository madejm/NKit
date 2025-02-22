import Foundation
#if canImport(AppKit)
import AppKit

extension NSImage {
    @MainActor
    public func view() -> NSView {
        let imageView = NSImageView(image: self)
        
        return imageView
    }
}
#endif
