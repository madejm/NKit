import Foundation
#if canImport(UIKit)
import UIKit

open class Button: UIButton {
    @NGet private var textBinding: String
    private let buttonAction: () -> Void
    
    public init(
        _ textBinding: NGet<String>,
        action: @escaping () -> Void
    ) {
        self._textBinding = textBinding
        self.buttonAction = action
        
        super.init(frame: .zero)
        
        self.setTitle(textBinding.wrappedValue, for: .normal)
        self.addTarget(self, action: #selector(touchAction), for: .touchUpInside)
        
        self._textBinding.onChange {
            self.setTitle($0, for: .normal)
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
