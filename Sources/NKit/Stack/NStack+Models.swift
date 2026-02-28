import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NVStack {
    public enum Alignment: Equatable, Hashable, Sendable, CaseIterable {
        case leading, center, trailing
        
        internal var alignment: BaseAlignment {
            switch self {
            case .leading:
                return .leading
            case .center:
                #if canImport(AppKit)
                return .centerX
                #elseif canImport(UIKit)
                return .center
                #endif
            case .trailing:
                return .trailing
            }
        }
    }
}

extension NHStack {
    public enum Alignment: Equatable, Hashable, Sendable, CaseIterable {
        case top, center, bottom
        
        internal var alignment: BaseAlignment {
            switch self {
            case .top:
                return .top
            case .center:
                #if canImport(AppKit)
                return .centerY
                #elseif canImport(UIKit)
                return .center
                #endif
            case .bottom:
                return .bottom
            }
        }
    }
}

extension NViewStack {
    #if canImport(AppKit)
    public typealias BaseAlignment = NSLayoutConstraint.Attribute
    public typealias Orientation = NSUserInterfaceLayoutOrientation
    #elseif canImport(UIKit)
    public typealias BaseAlignment = UIStackView.Alignment
    public typealias Orientation = NSLayoutConstraint.Axis
    #endif
}

#if canImport(AppKit)
#elseif canImport(UIKit)
extension UIStackView {
    /// Platform agnostic wrapper over `axis`.
    public var orientation: NSLayoutConstraint.Axis {
        get {
            axis
        }
        set {
            axis = newValue
        }
    }
}
#endif
