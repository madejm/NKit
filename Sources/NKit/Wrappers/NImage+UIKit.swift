import Foundation
#if canImport(UIKit)
import UIKit

open class NImage: UIImageView {
    @NGet private var imageBinding: UIImage?
    
    package var imageHooks: [(inout UIImage?) -> Void] = []
    
    open override var image: UIImage? {
        get {
            super.image
        }
        set {
            var image: UIImage? = newValue
            
            for hook in imageHooks {
                hook(&image)
            }
            
            super.image = image
        }
    }
    
    public init(
        _ imageBinding: NGet<UIImage?>,
        contentMode: ImageContentMode = .aspectFit
    ) {
        self._imageBinding = imageBinding
        
        super.init(frame: CGRect.zero)
        
        self.contentMode = contentMode.contentMode
        self.clipsToBounds = true
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        self.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        
        bind(imageBinding, to: \.image)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
