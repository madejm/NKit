import Foundation
#if canImport(AppKit)
import AppKit

public final class Text: NSTextField {
    @NGet private var textBinding: NSAttributedString
    
    public init(
        _ textBinding: NGet<NSAttributedString>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self._textBinding = textBinding
        
        super.init(frame: .zero)
        
        self.attributedStringValue = textBinding.wrappedValue
        self.isEditable = false
        self.drawsBackground = false
        self.isBezeled = false
        self.isSelectable = false
        self.alignment = alignment
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        if let cell = self.cell {
            cell.usesSingleLineMode = !multiline
            cell.wraps = multiline
            cell.lineBreakMode = .byWordWrapping
        }
        
        self._textBinding.onChange {
            self.attributedStringValue = $0
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
