import Foundation
#if canImport(UIKit)
import UIKit

open class NCheckbox: BaseView {
    @NGet private var titleBinding: String
    @NBinding private var stateBinding: Bool
    
    public init(
        title titleBinding: NGet<String>,
        state stateBinding: NBinding<Bool>
    ) {
        self._titleBinding = titleBinding
        self._stateBinding = stateBinding
        
        super.init()
        
        self.addSubviewAutomatically {
            NHStack(alignment: .center, spacing: 4) {
                NText(titleBinding)
                NSwitch(stateBinding)
            }
        }
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
