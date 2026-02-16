import Foundation
#if canImport(AppKit)
import AppKit

@MainActor
public protocol ClosableViewController {
    func windowDidClose()
}

open class NBaseViewController<View: NControlledView>: NSViewController, ClosableViewController {
    public let controlledView: View
    nonisolated(unsafe) private var releaseChecker: ReleaseChecker!
    nonisolated(unsafe) private var modelReleaseChecker: ReleaseChecker?
    
    public init(_ controlledView: View) {
        self.controlledView = controlledView
        
        super.init(nibName: nil, bundle: nil)
        
        self.releaseChecker = ReleaseChecker(self, name: String(describing: self))
        
        if let modelControlledView = controlledView as? (any NModelControlledView),
           let model = modelControlledView.model as? AnyObject {
            self.modelReleaseChecker = ReleaseChecker(
                model,
                name: "Model of \(String(describing: modelControlledView))"
            )
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.releaseChecker.confirm()
        self.modelReleaseChecker?.expect()
    }
    
    open override func loadView() {
        view = NSView(frame: .zero)
        view.wantsLayer = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviewAutomatically(controlledView.body)
    }
    
    open override func viewDidDisappear() {
        super.viewDidDisappear()
        
        self.releaseChecker.expect()
    }
    
    open func windowDidClose() {
    }
}
#endif
