import Foundation
#if canImport(AppKit)
import AppKit

open class BaseView: NSView {
    public init() {
        super.init(frame: .zero)
        
        self.layer = CALayer()
    }
    
    @available(*, unavailable)
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NSView {
    internal func prepare() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
}
#endif
