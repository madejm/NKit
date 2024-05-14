import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _Control {
    public func disabled(_ disabled: Bool) -> Self {
        self.disabled(NGet.constant(disabled))
    }
    
    public func disabled(_ disabledBinding: NBinding<Bool>) -> Self {
        self.disabled(disabledBinding.get)
    }
    
    public func disabled(_ disabledBinding: NGet<Bool>) -> Self {
        let initialValue: Bool = disabledBinding.wrappedValue
        
        self.isEnabled = !initialValue
        
        disabledBinding.onChange { [weak self] newValue in
            self?.isEnabled = !newValue
        }
        
        return self
    }
}
