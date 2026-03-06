import Foundation
#if canImport(UIKit)
import UIKit

open class NImage: UIImageView {
    @NGet private var imageBinding: UIImage?
    
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
