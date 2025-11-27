import Foundation
#if canImport(UIKit)
import UIKit

open class NBaseViewController: UIViewController {
    @NEnvironment(\.verticalSizeClass) private var verticalSizeClass
    @NEnvironment(\.horizontalSizeClass) private var horizontalSizeClass
    
    internal let controlledView: any NControlledView
    
    public init(_ controlledView: any NControlledView) {
        self.controlledView = controlledView
        
        super.init(nibName: nil, bundle: nil)
        
        self.verticalSizeClass = .init(self.traitCollection.verticalSizeClass)
        self.horizontalSizeClass = .init(self.traitCollection.horizontalSizeClass)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        view = controlledView.body
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.verticalSizeClass = .init(self.traitCollection.verticalSizeClass)
        self.horizontalSizeClass = .init(self.traitCollection.horizontalSizeClass)
    }
}
#endif
