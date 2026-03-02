import Foundation
#if canImport(AppKit)
import AppKit

open class NButton: NSButton {
    @NGet private var textBinding: String
    private let buttonAction: (NButton) -> Void
    private let stateBinding: NBinding<NSControl.StateValue>?
    
    open override var state: NSControl.StateValue {
        get {
            super.state
        }
        set {
            super.state = newValue
            stateBinding?.wrappedValue = newValue
        }
    }
    
    public convenience init(
        _ textBinding: NGet<String>,
        bezelStyle: NSButton.BezelStyle = .rounded,
        buttonType: NSButton.ButtonType = .momentaryPushIn,
        state stateBinding: NBinding<NSControl.StateValue>? = nil,
        @_inheritActorContext action: (() -> Void)? = nil
    ) {
        self.init(
            textBinding,
            bezelStyle: bezelStyle,
            buttonType: buttonType,
            state: stateBinding
        ) { _ in
            action?()
        }
    }
    
    public init(
        _ textBinding: NGet<String>,
        bezelStyle: NSButton.BezelStyle = .rounded,
        buttonType: NSButton.ButtonType = .momentaryPushIn,
        state stateBinding: NBinding<NSControl.StateValue>? = nil,
        @_inheritActorContext action: @escaping (NButton) -> Void
    ) {
        self._textBinding = textBinding
        self.buttonAction = action
        self.stateBinding = stateBinding
        
        super.init(frame: .zero)
        
        self.bezelStyle = bezelStyle
        self.setButtonType(buttonType)
        self.target = self
        self.action = #selector(touchAction)
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        
        self._textBinding.updating(view: self, keyPath: \.title)
        
        if let stateBinding {
            stateBinding.updating(view: self) { view, value in
                view.setSuperState(value)
            }
        }
    }
    
    private func setSuperState(_ newState: NSControl.StateValue) {
        super.state = newState
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchAction() {
        buttonAction(self)
        stateBinding?.wrappedValue = state
    }
}

extension NBinding<Bool> {
    public var controlState: NBinding<NSControl.StateValue> {
        self.map(
            up: {
                $0 ? .on : .off
            },
            down: {
                $0 == .on
            }
        )
    }
}
#endif
