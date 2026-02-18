import Foundation
#if canImport(AppKit)
import AppKit

public final class Input: NSTextField {
    @NBinding fileprivate var textBinding: String?
    private let didEndEditing: (() -> Void)?
    
    public convenience init(
        _ textBinding: NBinding<String>,
        placeholder: String? = nil,
        multiline: Bool = false,
        didEndEditing: (() -> Void)? = nil
    ) {
        self.init(
            textBinding.map(),
            placeholder: placeholder,
            multiline: multiline,
            didEndEditing: didEndEditing
        )
    }
    
    public init(
        _ textBinding: NBinding<String?>,
        placeholder: String? = nil,
        multiline: Bool = false,
        didEndEditing: (() -> Void)? = nil
    ) {
        self._textBinding = textBinding
        self.didEndEditing = didEndEditing
        
        super.init(frame: .zero)
        
        self.stringValue = textBinding.wrappedValue ?? ""
        self.placeholderString = placeholder
        self.delegate = self
        
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

extension Input: NSControlTextEditingDelegate {
    @MainActor public func controlTextDidEndEditing(_ obj: Notification) {
        if self.textBinding != self.stringValue {
            self.textBinding = self.stringValue
            didEndEditing?()
        }
    }
}

extension Input: NSTextFieldDelegate {
}

#endif
