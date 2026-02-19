import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Abstraction over a view or collection of views (in `ForEach`)
/// Think as of SwiftUI's `View`
@MainActor
public protocol NView {}
extension _View: NView {}

extension Array: NView where Element == NView {}

internal enum NViewUnpacked {
    case controlledView(NControlledView)
    case view(_View)
    case array([NView])
    case forEach(NForEach)
    case `if`(NIf)
    case otherObject(NView & AnyObject)
    case other(NView)
}

extension NView {
    
    internal var unpacked: NViewUnpacked {
        if let controlledView = self as? NControlledView {
            return .controlledView(controlledView)
        } else if let array = self as? [NView] {
            return .array(array)
        } else if let view = self as? _View {
            return .view(view)
        } else if let forEach = self as? NForEach {
            return .forEach(forEach)
        } else if let anIf = self as? NIf {
            return .if(anIf)
        } else if let object = self as? (NView & AnyObject) {
            return .otherObject(object)
        } else {
            return .other(self)
        }
    }
}
