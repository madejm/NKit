import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
public typealias _LayoutPriority = NSLayoutConstraint.Priority

extension NSLayoutConstraint.Priority {
    ///  510 (dragThatCanResizeWindow)
    public static let dragThatCanResize: NSLayoutConstraint.Priority    = .dragThatCanResizeWindow
    ///  500 (windowSizeStayPut)
    public static let sizeStayPut: NSLayoutConstraint.Priority          = .windowSizeStayPut
    ///  490 (dragThatCannotResizeWindow)
    public static let dragThatCannotResize: NSLayoutConstraint.Priority = .dragThatCannotResizeWindow
    ///   50 (fittingSizeCompression)
    public static let fittingSize: NSLayoutConstraint.Priority          = .fittingSizeCompression
}
#elseif canImport(UIKit)
public typealias _LayoutPriority = UILayoutPriority

extension UILayoutPriority {
    ///  510 (dragThatCanResizeScene)
    public static let dragThatCanResize: UILayoutPriority    = .dragThatCanResizeScene
    ///  500 (sceneSizeStayPut)
    public static let sizeStayPut: UILayoutPriority          = .sceneSizeStayPut
    ///  490 (dragThatCannotResizeScene)
    public static let dragThatCannotResize: UILayoutPriority = .dragThatCannotResizeScene
    ///   50 (fittingSizeLevel)
    public static let fittingSize: UILayoutPriority          = .fittingSizeLevel
}
#endif

public struct NLayoutPriority: Hashable, Equatable, RawRepresentable, Sendable {
    public let rawValue: Float
    
    public init(_ rawValue: Float) {
        self.rawValue = rawValue
    }
    
    public init(rawValue: Float) {
        self.rawValue = rawValue
    }
    
    public init(_ priority: _LayoutPriority) {
        self.rawValue = priority.rawValue
    }
    
    public var priority: _LayoutPriority {
        _LayoutPriority(self)
    }
    
    /// 1000
    public static let required: NLayoutPriority             = .init(_LayoutPriority.required)
    ///  750
    public static let defaultHigh: NLayoutPriority          = .init(_LayoutPriority.defaultHigh)
    ///  510
    public static let dragThatCanResize: NLayoutPriority    = .init(_LayoutPriority.dragThatCanResize)
    ///  500
    public static let sizeStayPut: NLayoutPriority          = .init(_LayoutPriority.sizeStayPut)
    ///  490
    public static let dragThatCannotResize: NLayoutPriority = .init(_LayoutPriority.dragThatCannotResize)
    ///  250
    public static let defaultLow: NLayoutPriority           = .init(_LayoutPriority.defaultLow)
    ///   50
    public static let fittingSize: NLayoutPriority          = .init(_LayoutPriority.fittingSize)
}

extension _LayoutPriority {
    
    public init(_ layoutPriority: NLayoutPriority) {
        self.init(rawValue: layoutPriority.rawValue)
    }
    
    public var layoutPriority: NLayoutPriority {
        NLayoutPriority(self)
    }
}

extension NSLayoutConstraint {
    public var layoutPriority: NLayoutPriority {
        get {
            self.priority.layoutPriority
        }
        set {
            self.priority = newValue.priority
        }
    }
}

extension NLayoutPriority {
    public static func + (lhs: NLayoutPriority, rhs: NLayoutPriority) -> NLayoutPriority {
        NLayoutPriority(lhs.rawValue + rhs.rawValue)
    }
    
    public static func - (lhs: NLayoutPriority, rhs: NLayoutPriority) -> NLayoutPriority {
        NLayoutPriority(lhs.rawValue - rhs.rawValue)
    }
    
    public static func + (lhs: NLayoutPriority, rhs: Float) -> NLayoutPriority {
        NLayoutPriority(lhs.rawValue + rhs)
    }
    
    public static func - (lhs: NLayoutPriority, rhs: Float) -> NLayoutPriority {
        NLayoutPriority(lhs.rawValue - rhs)
    }
    
    public static func + (lhs: Float, rhs: NLayoutPriority) -> NLayoutPriority {
        NLayoutPriority(lhs + rhs.rawValue)
    }
    
    public static func - (lhs: Float, rhs: NLayoutPriority) -> NLayoutPriority {
        NLayoutPriority(lhs - rhs.rawValue)
    }
}
