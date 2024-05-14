import Foundation
#if canImport(AppKit)
import AppKit

public final class Input: NSTextField {
    @NBinding private var textBinding: String?
    
    public convenience init(
        _ textBinding: NBinding<String>,
        placeholder: String? = nil,
        multiline: Bool = false
    ) {
        self.init(
            textBinding.map(),
            placeholder: placeholder,
            multiline: multiline
        )
    }
    
    public init(
        _ textBinding: NBinding<String?>,
        placeholder: String? = nil,
        multiline: Bool = false
    ) {
        self._textBinding = textBinding
        
        super.init(frame: .zero)
        
        self.stringValue = textBinding.wrappedValue ?? ""
        self.placeholderString = placeholder
        
        if let cell = self.cell {
            cell.usesSingleLineMode = !multiline
            cell.wraps = multiline
            cell.lineBreakMode = .byWordWrapping
        }
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        self._textBinding.onChange {
            self.stringValue = $0 ?? ""
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
