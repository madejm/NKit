import Foundation
#if canImport(AppKit)
import AppKit

open class BaseView: NSView {
    public init() {
        super.init(frame: .zero)
        
        self.layer = CALayer()
        self.clipsToBounds = false
        self.prepare()
    }
    
    @available(*, unavailable)
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.didMoveToSuperview()
    }
    
    open func didMoveToSuperview() {
    }
}

extension NSView {
    internal func prepare() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = NSColor.clear
    }
}
#endif
