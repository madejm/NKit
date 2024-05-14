import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension Button {
    public convenience init(
        _ text: String,
        action: @escaping () -> Void
    ) {
        self.init(NGet.constant(text), action: action)
    }
    
    public convenience init(
        _ textBinding: NBinding<String>,
        action: @escaping () -> Void
    ) {
        self.init(textBinding.get, action: action)
    }
}
