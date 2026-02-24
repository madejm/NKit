import Foundation
#if canImport(AppKit)
import AppKit

open class NSwitch: NSSwitch {
    @NBinding private var stateBinding: Bool
    
    public init(
        _ stateBinding: NBinding<Bool>
    ) {
        self._stateBinding = stateBinding
        
        super.init(frame: .zero)
        
        self.state = stateBinding.wrappedValue ? .on : .off
        self.target = self
        self.action = #selector(touchAction)
        
        self._stateBinding.onChange { [weak self] in
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
