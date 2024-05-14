#if canImport(AppKit)
import AppKit
public typealias _ViewController = NSViewController
public typealias _View = NSView
public typealias _Control = NSControl
public typealias _Color = NSColor
public typealias _Image = NSImage
internal typealias _Stack = NSStackView
#elseif canImport(UIKit)
import UIKit
public typealias _ViewController = UIViewController
public typealias _View = UIView
public typealias _Control = UIControl
public typealias _Color = UIColor
public typealias _Image = UIImage
internal typealias _Stack = UIStackView
#endif

public protocol HasApply {}
extension _View: HasApply {}

extension HasApply {
    public func apply(
        _ modifier: (Self) -> Void
    ) -> Self {
        modifier(self)
        
        return self
    }
}
