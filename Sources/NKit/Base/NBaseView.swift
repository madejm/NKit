//
//  NBaseView.swift
//  NKit
//
//  Created by Mejdej on 17/02/2026.
//

open class NBaseView<View: NControlledView>: BaseView {
    public let view: View
    nonisolated(unsafe) private var releaseChecker: ReleaseChecker!
    
    public init(_ view: View) {
        self.view = view
        
        super.init()
        
        self.releaseChecker = ReleaseChecker(self, name: String(describing: self))
        
        self.prepare()
        
        self.addSubviewAutomatically(view.body)
    }
    
    deinit {
        self.releaseChecker.confirm()
    }
    
    open override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.releaseChecker.cancelExpectation()
    }
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        self.releaseChecker.expect()
    }
}
