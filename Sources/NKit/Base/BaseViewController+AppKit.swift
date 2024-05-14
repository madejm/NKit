import Foundation
#if canImport(AppKit)
import AppKit

open class BaseViewController: NSViewController {
    private let customView: NSView
    public init(_ customView: NSView) {
        self.customView = customView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = customView
        view.wantsLayer = true
    }
}
#endif
