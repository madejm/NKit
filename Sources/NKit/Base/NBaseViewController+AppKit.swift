import Foundation
#if canImport(AppKit)
import AppKit

@MainActor
public protocol ClosableViewController {
    func windowDidClose()
}

public typealias NBaseViewController = _NBaseViewController & NBaseViewControllerProtocol

@MainActor
public protocol NBaseViewControllerProtocol {
    associatedtype View: NControlledView
}

extension NBaseViewControllerProtocol where Self: _NBaseViewController {
    public var controlledView: View {
        self._controlledView as! View
    }
    
    fileprivate func checkError(anyView: any NControlledView) -> String? {
        guard type(of: anyView) == View.self else {
            return String(reflecting: View.self)
        }
        return nil
    }
}

open class _NBaseViewController: NSViewController, ClosableViewController {
    fileprivate let _controlledView: any NControlledView
    private let releaseChecker = ReleaseChecker()
    nonisolated(unsafe) private var modelReleaseChecker: ReleaseChecker?
    
    public init<ControlledView: NControlledView>(_ controlledView: ControlledView) {
        self._controlledView = controlledView
        
        super.init(nibName: nil, bundle: nil)
        
        guard let protocolType = self as? (any NBaseViewController) else {
            fatalError("_NBaseViewController is an abstract class, use NBaseViewController instead.")
        }
        if let error = protocolType.checkError(anyView: controlledView) {
            fatalError("Trying to initialize \(String(reflecting: Self.self)) with wrong view type of \(String(reflecting: ControlledView.self)), should be \(error).")
        }
        
        self.releaseChecker.prepare(self)
        
        if let modelControlledView = controlledView as? (any NModelControlledView),
           let model = modelControlledView.model as? AnyObject {
            let modelReleaseChecker = ReleaseChecker()
            modelReleaseChecker.prepare(
                model,
                customName: "Model of \(String(reflecting: modelControlledView))"
            )
            self.modelReleaseChecker = modelReleaseChecker
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
        let body = _controlledView.body
        view.addSubviewAutomatically(body)
    }
    
    open override func viewWillAppear() {
        super.viewWillAppear()
        
        self.releaseChecker.cancelExpectation()
    }
    
    open override func viewDidDisappear() {
        super.viewDidDisappear()
        
        self.releaseChecker.expect()
    }
    
    open func windowDidClose() {
    }
}
#endif
