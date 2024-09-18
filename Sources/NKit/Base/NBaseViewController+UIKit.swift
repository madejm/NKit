import Foundation
#if canImport(UIKit)
import UIKit

open class NBaseViewController: UIViewController {
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
        view = controlledView.body
    }
}
#endif
