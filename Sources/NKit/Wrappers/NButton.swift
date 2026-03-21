import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
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
        action: @escaping @MainActor () -> Void
    ) {
        self.init(
            NGet.constant(text),
            action: action
        )
    }
    
    public convenience init(
        _ textBinding: NBinding<String>,
        action: @escaping @MainActor () -> Void
    ) {
        self.init(
            textBinding.get,
            action: action
        )
    }
}
#endif

extension NButton {
    public convenience init(
        action: @escaping @MainActor () -> Void,
        label: () -> _View
    ) {
        self.init(
            action: { _ in
                action()
            },
            label: label
        )
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState var text2: String = "Hello 2"
    
    NViewPreview {
        NVStack {
            NButton("Hello 1") {
                print("Hello 1")
            }
            .background(.black)
            
            NButton($text2) {
                text2 = text2 == "Hello 2" ? "Hello CHANGED" : "Hello 2"
                print(text2)
            }
            .background(.black)
            
            #if canImport(AppKit)
            NButton(
                "Hello 3",
                bezelStyle: .flexiblePush,
                buttonType: .pushOnPushOff,
            ) {
                print("Hello 3")
            }
            .frame(width: 100, height: 100)
            .background(.black)
            #endif
            
            NButton(
                action: {
                    print("Hello 4")
                },
                label: {
                    NText("Hello 4")
                        .foregroundStyle(.white)
                        .padding(20)
                        .background {
                            NImage(_Image(named: "lena", in: .module)!, contentMode: .aspectFill)
                                .opacity(0.5)
                        }
                }
            )
            .background(.black)
        }
    }
    .padding()
    .background(.white)
}
#endif
