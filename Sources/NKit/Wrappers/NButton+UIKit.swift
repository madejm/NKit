import Foundation
#if canImport(UIKit)
import UIKit

open class NButton: UIButton {
    @NGet private var textBinding: String
    private let buttonAction: (NButton) -> Void
    
    public convenience init(
        _ textBinding: NGet<String>,
        action: (@MainActor () -> Void)? = nil
    ) {
        self.init(
            textBinding
        ) { _ in
            action?()
        }
    }
    
    public init(
        _ textBinding: NGet<String>,
        action: @escaping @MainActor (NButton) -> Void
    ) {
        self._textBinding = textBinding
        self.buttonAction = action
        
        super.init(frame: .zero)
        
        self.addTarget(self, action: #selector(touchAction), for: .touchUpInside)
        
        self._textBinding.updating(view: self) { view, value in
            view.setTitle(value, for: .normal)
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchAction() {
        buttonAction(self)
    }
}
#endif
