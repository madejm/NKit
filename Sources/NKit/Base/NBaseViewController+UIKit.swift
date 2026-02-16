import Foundation
#if canImport(UIKit)
import UIKit

open class NBaseViewController<View: NControlledView>: UIViewController {
    internal let controlledView: View
    
    public init(_ controlledView: View) {
        self.controlledView = controlledView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = controlledView.body
    }
}
#endif
