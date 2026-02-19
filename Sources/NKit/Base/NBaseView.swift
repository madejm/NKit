//
//  NBaseView.swift
//  NKit
//
//  Created by Mejdej on 17/02/2026.
//

public typealias NBaseView = _NBaseView & NBaseViewProtocol

@MainActor
public protocol NBaseViewProtocol {
    associatedtype View: NControlledView
}

extension NBaseViewProtocol where Self: _NBaseView {
    public var view: View {
        self._view as! View
    }
    
    fileprivate func checkError(anyView: any NControlledView) -> String? {
        guard type(of: anyView) == View.self else {
            return String(reflecting: View.self)
        }
        return nil
    }
}

open class _NBaseView: BaseView {
    fileprivate let _view: any NControlledView
    nonisolated(unsafe) private var releaseChecker: ReleaseChecker!
    
    public init<ControlledView: NControlledView>(_ view: ControlledView) {
        self._view = view
        
        super.init()
        
        guard let protocolType = self as? (any NBaseView) else {
            fatalError("_NBaseView is an abstract class, use NBaseView instead.")
        }
        if let error = protocolType.checkError(anyView: view) {
            fatalError("Trying to initialize \(String(reflecting: Self.self)) with wrong view type of \(String(reflecting: ControlledView.self)), should be \(error).")
        }
        
        self.releaseChecker = ReleaseChecker(self, name: String(describing: self))
        
        self.prepare()
        
        self.addSubviewAutomatically(view.body)
    }
    
    deinit {
        self.releaseChecker.confirm()
    }
    
    #if canImport(AppKit)
    open override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.releaseChecker.cancelExpectation()
    }
    #elseif canImport(UIKit)
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.releaseChecker.cancelExpectation()
    }
    #endif
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        self.releaseChecker.expect()
    }
}
