import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NVStack {
    public enum Alignment {
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
    public enum Alignment {
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

extension ViewStack {
    #if canImport(AppKit)
    public typealias BaseAlignment = NSLayoutConstraint.Attribute
    public typealias Orientation = NSUserInterfaceLayoutOrientation
    #elseif canImport(UIKit)
    public typealias BaseAlignment = UIStackView.Alignment
    public typealias Orientation = NSLayoutConstraint.Axis
    #endif
    
    public enum Stretching {
        case none
        case horizontal
        case vertical
        case all
    }
}
