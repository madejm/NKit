import Foundation
#if canImport(UIKit)
import UIKit

open class NButton: UIButton {
    private let buttonAction: (NButton) -> Void
    private let textBinding: NGet<String>?
    
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
        self.textBinding = textBinding
        self.buttonAction = action
        
        super.init(frame: .zero)
        
        self.addTarget(self, action: #selector(touchAction), for: .touchUpInside)
        
        bind(textBinding) { [weak self] in
            self?.setTitle($0, for: .normal)
        }
    }
    
    public init(
        action: @escaping @MainActor (NButton) -> Void,
        label: () -> _View
    ) {
        self.textBinding = nil
        self.buttonAction = action
        
        super.init(frame: .zero)
        
        self.addTarget(self, action: #selector(touchAction), for: .touchUpInside)
        
        let customView: _View = label()
        customView.isUserInteractionEnabled = false
        addSubviewAutomatically(customView)
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
