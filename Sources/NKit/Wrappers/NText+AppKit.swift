import Foundation
#if canImport(AppKit)
import AppKit

public final class NText: NSTextField {
    @NGet private var textBinding: NSAttributedString
    
    #if DEBUG
    nonisolated(unsafe) internal var debugStringValue: String
    #endif
    
    public init(
        _ textBinding: NGet<NSAttributedString>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self._textBinding = textBinding
        
        #if DEBUG
        self.debugStringValue = textBinding.wrappedValue.string
        #endif
        
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
        
        self._textBinding.onChange { [weak self] in
            self?.attributedStringValue = $0
            
            #if DEBUG
            self?.debugStringValue = $0.string
            #endif
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print_debug("💥 DEINIT Text \"\(debugStringValue)\"")
        #endif
    }
}

#if swift(>=6.1)
extension NText: @MainActor CustomReflectable {
    public var customMirror: Mirror {
        Mirror(self, children: ["stringValue": stringValue])
    }
}
#else
extension NText: @preconcurrency CustomReflectable {
    public var customMirror: Mirror {
        Mirror(self, children: ["stringValue": stringValue])
    }
}
#endif
#endif
