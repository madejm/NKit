import Foundation
#if canImport(UIKit)
import UIKit

public final class Text: UILabel {
    @NGet private var textBinding: NSAttributedString
    
    public init(
        _ textBinding: NGet<NSAttributedString>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = false
    ) {
        self._textBinding = textBinding
        
        super.init(frame: .zero)
        
        self.attributedText = textBinding.wrappedValue
        self.textAlignment = alignment
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        
        self._textBinding.onChange {
            self.attributedText = $0
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

