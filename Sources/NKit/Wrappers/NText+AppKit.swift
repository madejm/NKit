import Foundation
#if canImport(AppKit)
import AppKit

public final class NText: NSTextField {
    
    #if DEBUG
    nonisolated(unsafe) internal var debugStringValue: String = ""
    #endif
    
    public convenience init(
        _ textBinding: NGet<String>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self.init(
            alignment: alignment,
            multiline: multiline
        )
        
        #if DEBUG
        self.debugStringValue = textBinding.wrappedValue
        #endif
        
        bind(
            textBinding,
            to: \.stringValue,
            animationTransitionType: .fade,
            additionalUpdates: { [weak self] in
                #if DEBUG
                self?.debugStringValue = $0
                #endif
            }
        )
    }
    
    public convenience init(
        _ textBinding: NGet<NSAttributedString>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self.init(
            alignment: alignment,
            multiline: multiline
        )
        
        #if DEBUG
        self.debugStringValue = textBinding.wrappedValue.string
        #endif
            
        bind(
            textBinding,
            to: \.attributedStringValue,
            animationTransitionType: .fade,
            additionalUpdates: { [weak self] in
                #if DEBUG
                self?.debugStringValue = $0.string
                #endif
            }
        )
    }
    
    private init(
        alignment: NSTextAlignment,
        multiline: Bool
    ) {
        super.init(frame: .zero)
        
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
