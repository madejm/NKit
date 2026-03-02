import Foundation
#if canImport(AppKit)
import AppKit

public final class NInput: NSTextField {
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
        
        self.placeholderString = placeholder
        self.delegate = self
        
        if let cell = self.cell {
            cell.usesSingleLineMode = !multiline
            cell.wraps = multiline
            cell.lineBreakMode = .byWordWrapping
        }
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        self._textBinding.updating(view: self) { view, value in
            view.stringValue = value ?? ""
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NInput: NSControlTextEditingDelegate {
    @MainActor public func controlTextDidEndEditing(_ obj: Notification) {
        if self.textBinding != self.stringValue {
            self.textBinding = self.stringValue
            didEndEditing?()
        }
    }
}

extension NInput: NSTextFieldDelegate {
}

#endif
