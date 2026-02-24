import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
extension NButton {
    public convenience init(
        _ text: String,
        bezelStyle: NSButton.BezelStyle = .rounded,
        buttonType: NSButton.ButtonType = .momentaryPushIn,
        state stateBinding: NBinding<NSControl.StateValue>? = nil,
        action: (() -> Void)? = nil
    ) {
        self.init(
            NGet.constant(text),
            bezelStyle: bezelStyle,
            buttonType: buttonType,
            state: stateBinding,
            action: action
        )
    }
    
    public convenience init(
        _ text: String,
        bezelStyle: NSButton.BezelStyle = .rounded,
        buttonType: NSButton.ButtonType = .momentaryPushIn,
        state stateBinding: NBinding<NSControl.StateValue>? = nil,
        action: @escaping (NButton) -> Void
    ) {
        self.init(
            NGet.constant(text),
            bezelStyle: bezelStyle,
            buttonType: buttonType,
            state: stateBinding,
            action: action
        )
    }
    
    public convenience init(
        _ textBinding: NBinding<String>,
        bezelStyle: NSButton.BezelStyle = .rounded,
        buttonType: NSButton.ButtonType = .momentaryPushIn,
        state stateBinding: NBinding<NSControl.StateValue>? = nil,
        action: (() -> Void)? = nil
    ) {
        self.init(
            textBinding.get,
            bezelStyle: bezelStyle,
            buttonType: buttonType,
            state: stateBinding,
            action: action
        )
    }
    
    public convenience init(
        _ textBinding: NBinding<String>,
        bezelStyle: NSButton.BezelStyle = .rounded,
        buttonType: NSButton.ButtonType = .momentaryPushIn,
        state stateBinding: NBinding<NSControl.StateValue>? = nil,
        action: @escaping (NButton) -> Void
    ) {
        self.init(
            textBinding.get,
            bezelStyle: bezelStyle,
            buttonType: buttonType,
            state: stateBinding,
            action: action
        )
    }
}
#elseif canImport(UIKit)
extension NButton {
    public convenience init(
        _ text: String,
        action: @escaping () -> Void
    ) {
        self.init(
            NGet.constant(text),
            action: action
        )
    }
    
    public convenience init(
        _ textBinding: NBinding<String>,
        action: @escaping () -> Void
    ) {
        self.init(
            textBinding.get,
            action: action
        )
    }
}
#endif
