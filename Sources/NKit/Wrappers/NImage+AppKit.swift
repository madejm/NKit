import Foundation
#if canImport(AppKit)
import AppKit

open class NImage: NSImageView {
    @NGet private var imageBinding: NSImage?
    
    public init(_ imageBinding: NGet<NSImage?>) {
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
