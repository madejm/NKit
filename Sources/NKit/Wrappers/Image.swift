import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension Image {
    public convenience init(_ image: _Image) {
        self.init(NGet.constant(image))
    }
    
    public convenience init(_ imageBinding: NBinding<_Image>) {
        self.init(imageBinding.get)
    }
}
