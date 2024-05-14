import Foundation
#if canImport(UIKit)
import UIKit

open class BaseView: UIView {
    public init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    public override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    internal func prepare() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
    }
}
#endif
