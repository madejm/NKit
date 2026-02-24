import Foundation
#if canImport(UIKit)
import UIKit

open class NSwitch: UISwitch {
    @NBinding private var stateBinding: Bool
    
    public init(
        _ stateBinding: NBinding<Bool>
    ) {
        self._stateBinding = stateBinding
        
        super.init(frame: .zero)
        
        self.isOn = stateBinding.wrappedValue
        self.addTarget(self, action: #selector(touchAction), for: .valueChanged)
        
        self._stateBinding.onChange { [weak self] in
            self?.isOn = $0
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchAction() {
        self.stateBinding = self.isOn
    }
}
#endif
