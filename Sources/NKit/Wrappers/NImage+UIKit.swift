import Foundation
#if canImport(UIKit)
import UIKit

open class NImage: UIImageView {
    @NGet private var imageBinding: UIImage?
    
    public init(_ imageBinding: NGet<UIImage?>) {
        self._imageBinding = imageBinding
        
        super.init(frame: CGRect.zero)
        
        self._imageBinding.updating(view: self) { view, value in
            view.image = value
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
