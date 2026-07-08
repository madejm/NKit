import Foundation
#if canImport(AppKit)
import AppKit

open class NImage: NSImageView {
    @NGet private var imageBinding: NSImage?
    
    package var imageHooks: [(inout NSImage?) -> Void] = []
    
    open override var image: NSImage? {
        get {
            super.image
        }
        set {
            var image: NSImage? = newValue
            
            for hook in imageHooks {
                hook(&image)
            }
            
//            self.layer?.contents = image
            super.image = image
        }
    }
    
    public init(
        _ imageBinding: NGet<NSImage?>,
        contentMode: ImageContentMode = .aspectFit
    ) {
        self._imageBinding = imageBinding
        
        super.init(frame: CGRect.zero)
        
//        self.layer = CALayer()
//        self.wantsLayer = true
//        self.layer?.contentsGravity = contentMode.contentsGravity
//        self.layer?.masksToBounds = true
        self.imageAlignment = contentMode.imageAlignment
        self.imageScaling = contentMode.imageScaling
        
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
