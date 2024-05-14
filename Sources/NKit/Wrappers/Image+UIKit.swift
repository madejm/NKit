import Foundation
#if canImport(UIKit)
import UIKit

open class Image: UIImageView {
    @NGet private var imageBinding: UIImage
    
    public init(_ imageBinding: NGet<UIImage>) {
        self._imageBinding = imageBinding
        
        super.init(frame: CGRect.zero)
        
        self.image = imageBinding.wrappedValue
        
        self._imageBinding.onChange {
            self.image = $0
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
