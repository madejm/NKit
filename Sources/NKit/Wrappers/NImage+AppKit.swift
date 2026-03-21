import Foundation
#if canImport(AppKit)
import AppKit

open class NImage: NSImageView {
    @NGet private var imageBinding: NSImage?
    
    public override var image: NSImage? {
        get {
            super.image
        }
        set {
            self.layer?.contents = newValue
            super.image = newValue
        }
    }
    
    public init(
        _ imageBinding: NGet<NSImage?>,
        contentMode: ImageContentMode = .aspectFit
    ) {
        self._imageBinding = imageBinding
        
        super.init(frame: CGRect.zero)
        
        self.layer = CALayer()
        self.wantsLayer = true
        self.layer?.contentsGravity = contentMode.contentsGravity
        self.layer?.masksToBounds = true
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.fittingSizeCompression, for: .horizontal)
        self.setContentCompressionResistancePriority(.fittingSizeCompression, for: .vertical)
        
        bind(imageBinding, to: \.image)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
