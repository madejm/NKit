import Foundation
#if canImport(UIKit)
import UIKit

open class BaseViewController: UIViewController {
    private let customView: UIView
    public init(_ customView: UIView) {
        self.customView = customView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = customView
    }
}
#endif
