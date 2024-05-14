import Foundation
#if canImport(AppKit)
import AppKit

open class Image: NSImageView {
    @NGet private var imageBinding: NSImage
    
    public init(_ imageBinding: NGet<NSImage>) {
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
