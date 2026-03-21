import Foundation
#if canImport(AppKit)
import AppKit

open class NButton: NSButton {
    private let buttonAction: (NButton) -> Void
    private let textBinding: NGet<String>?
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
        self.textBinding = textBinding
        self.buttonAction = action
        self.stateBinding = stateBinding
        
        super.init(frame: .zero)
        
        self.bezelStyle = bezelStyle
        self.setButtonType(buttonType)
        self.target = self
        self.action = #selector(touchAction)
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        
        bind(textBinding, to: \.title)
        
        if let stateBinding {
            bind(stateBinding) { [weak self] in
                self?.setSuperState($0)
            }
        }
    }
    
    public init(
        @_inheritActorContext action: @escaping (NButton) -> Void,
        label: () -> _View
    ) {
        self.textBinding = nil
        self.stateBinding = nil
        self.buttonAction = action
        
        super.init(frame: .zero)
        
        self.title = ""
        self.bezelStyle = .flexiblePush
        self.setButtonType(.momentaryPushIn)
        self.target = self
        self.action = #selector(touchAction)
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        
        let customView: _View = label()
        addSubviewAutomatically(customView)
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
