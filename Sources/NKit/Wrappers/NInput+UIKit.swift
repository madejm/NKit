import Foundation
#if canImport(UIKit)
import UIKit

public final class NInput: UITextField {
    @NBinding private var textBinding: String?
    
    public convenience init(
        _ textBinding: NBinding<String>,
        placeholder: String? = nil
    ) {
        self.init(
            textBinding.map(),
            placeholder: placeholder
        )
    }
    
    public init(
        _ textBinding: NBinding<String?>,
        placeholder: String? = nil
    ) {
        self._textBinding = textBinding
        
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        bind(textBinding) { [weak self] in
            self?.text = $0 ?? ""
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
