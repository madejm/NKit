import Foundation
#if canImport(AppKit)
import AppKit

open class Button: NSButton {
    @NGet private var textBinding: String
    private let buttonAction: () -> Void
    
    public init(
        _ textBinding: NGet<String>,
        action: @escaping () -> Void
    ) {
        self._textBinding = textBinding
        self.buttonAction = action
        
        super.init(frame: .zero)
        
        self.bezelStyle = .rounded
        self.setButtonType(.momentaryPushIn)
        self.title = textBinding.wrappedValue
        self.target = self
        self.action = #selector(touchAction)
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        
        self._textBinding.onChange {
            self.title = $0
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchAction() {
        buttonAction()
    }
}
#endif
