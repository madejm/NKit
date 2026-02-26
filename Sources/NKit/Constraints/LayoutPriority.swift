import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
public typealias _LayoutPriority = NSLayoutConstraint.Priority

extension NSLayoutConstraint.Priority {
    fileprivate static let dragThatCanResize: NSLayoutConstraint.Priority    = .dragThatCanResizeWindow
    fileprivate static let sizeStayPut: NSLayoutConstraint.Priority          = .windowSizeStayPut
    fileprivate static let dragThatCannotResize: NSLayoutConstraint.Priority = .dragThatCannotResizeWindow
    fileprivate static let fittingSize: NSLayoutConstraint.Priority          = .fittingSizeCompression
}
#elseif canImport(UIKit)
public typealias _LayoutPriority = UILayoutPriority

extension UILayoutPriority {
    fileprivate static let dragThatCanResize: UILayoutPriority    = .dragThatCanResizeScene
    fileprivate static let sizeStayPut: UILayoutPriority          = .sceneSizeStayPut
    fileprivate static let dragThatCannotResize: UILayoutPriority = .dragThatCannotResizeScene
    fileprivate static let fittingSize: UILayoutPriority          = .fittingSizeLevel
}
#endif

public struct LayoutPriority: Hashable, Equatable, RawRepresentable, Sendable {
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
    public static let required: LayoutPriority             = .init(_LayoutPriority.required)
    ///  750
    public static let defaultHigh: LayoutPriority          = .init(_LayoutPriority.defaultHigh)
    ///  510
    public static let dragThatCanResize: LayoutPriority    = .init(_LayoutPriority.dragThatCanResize)
    ///  500
    public static let sizeStayPut: LayoutPriority          = .init(_LayoutPriority.sizeStayPut)
    ///  490
    public static let dragThatCannotResize: LayoutPriority = .init(_LayoutPriority.dragThatCannotResize)
    ///  250
    public static let defaultLow: LayoutPriority           = .init(_LayoutPriority.defaultLow)
    ///   50
    public static let fittingSize: LayoutPriority          = .init(_LayoutPriority.fittingSize)
}

extension _LayoutPriority {
    
    public init(_ layoutPriority: LayoutPriority) {
        self.init(rawValue: layoutPriority.rawValue)
    }
    
    public var layoutPriority: LayoutPriority {
        LayoutPriority(self)
    }
}

extension NSLayoutConstraint {
    public var layoutPriority: LayoutPriority {
        get {
            self.priority.layoutPriority
        }
        set {
            self.priority = newValue.priority
        }
    }
}
