import Foundation
#if canImport(AppKit)
import AppKit

open class Checkbox: NSButton {
    @NGet private var titleBinding: String
    @NBinding private var stateBinding: Bool
    
    public convenience init(
        title: String,
        state stateBinding: NBinding<Bool>
    ) {
        self.init(
            title: NGet.constant(title),
            state: stateBinding
        )
    }
    
    public init(
        title titleBinding: NGet<String>,
        state stateBinding: NBinding<Bool>
    ) {
        self._titleBinding = titleBinding
        self._stateBinding = stateBinding
        
        super.init(frame: .zero)
        
        self.setButtonType(.switch)
        self.title = titleBinding.wrappedValue
        self.state = stateBinding.wrappedValue ? .on : .off
        self.target = self
        self.action = #selector(touchAction)
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        
        self._titleBinding.onChange {
            self.title = $0
        }
        self._stateBinding.onChange {
            self.state = $0 ? .on : .off
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchAction() {
        self.stateBinding = self.state == .on
    }
}
#endif
