import Foundation
#if canImport(AppKit)
import AppKit

open class NBaseViewController: NSViewController {
    internal let controlledView: NControlledView
    
    public init(_ controlledView: NControlledView) {
        self.controlledView = controlledView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = NSView(frame: .zero)
        view.wantsLayer = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviewAutomatically(controlledView.body)
    }
}
#endif
