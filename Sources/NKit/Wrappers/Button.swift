import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension Button {
    public convenience init(
        _ text: String,
        bezelStyle: NSButton.BezelStyle = .rounded,
        action: @escaping () -> Void
    ) {
        self.init(
            NGet.constant(text),
            bezelStyle: bezelStyle,
            action: action
        )
    }
    
    public convenience init(
        _ textBinding: NBinding<String>,
        bezelStyle: NSButton.BezelStyle = .rounded,
        action: @escaping () -> Void
    ) {
        self.init(
            textBinding.get,
            bezelStyle: bezelStyle,
            action: action
        )
    }
}
