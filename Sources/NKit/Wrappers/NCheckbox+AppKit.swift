import Foundation
#if canImport(AppKit)
import AppKit

open class NCheckbox: NSButton {
    @NGet private var titleBinding: String
    @NBinding private var stateBinding: Bool
    
    public init(
        title titleBinding: NGet<String>,
        state stateBinding: NBinding<Bool>
    ) {
        self._titleBinding = titleBinding
        self._stateBinding = stateBinding
        
        super.init(frame: .zero)
        
        self.setButtonType(.switch)
        self.target = self
        self.action = #selector(touchAction)
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        
        bind(titleBinding, to: \.title)
        bind(stateBinding) { [weak self] in
            self?.state = $0 ? .on : .off
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
