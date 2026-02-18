import Foundation
#if canImport(AppKit)
import AppKit

open class Button: NSButton {
    @NGet private var textBinding: String
    private let buttonAction: (Button) -> Void
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
        @_inheritActorContext action: @escaping () -> Void
    ) {
        self.init(
            textBinding,
            bezelStyle: bezelStyle,
            buttonType: buttonType,
            state: stateBinding
        ) { _ in
            action()
        }
    }
    
    public init(
        _ textBinding: NGet<String>,
        bezelStyle: NSButton.BezelStyle = .rounded,
        buttonType: NSButton.ButtonType = .momentaryPushIn,
        state stateBinding: NBinding<NSControl.StateValue>? = nil,
        @_inheritActorContext action: @escaping (_ sender: Button) -> Void
    ) {
        self._textBinding = textBinding
        self.buttonAction = action
        self.stateBinding = stateBinding
        
        super.init(frame: .zero)
        
        self.bezelStyle = bezelStyle
        self.setButtonType(buttonType)
        self.title = textBinding.wrappedValue
        self.target = self
        self.action = #selector(touchAction)
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        
        self._textBinding.onChange { [weak self] in
            self?.title = $0
        }
        
        if let stateBinding {
            self.setSuperState(stateBinding.wrappedValue)
            
            stateBinding.onChange { [weak self] in
                self?.setSuperState($0)
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
#endif
