import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@MainActor
internal protocol NLayoutGuide {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

#if canImport(AppKit)
extension NSView: NLayoutGuide {
    @inline(__always)
    internal var nSafeAreaLayoutGuide: NLayoutGuide {
        if #available(macOS 11.0, *) {
            safeAreaLayoutGuide
        } else {
            self
        }
    }
}
extension NSLayoutGuide: NLayoutGuide {}
#elseif canImport(UIKit)
extension UIView: NLayoutGuide {
    @inline(__always)
    internal var nSafeAreaLayoutGuide: NLayoutGuide {
        safeAreaLayoutGuide
    }
}
extension UILayoutGuide: NLayoutGuide {}
#endif
