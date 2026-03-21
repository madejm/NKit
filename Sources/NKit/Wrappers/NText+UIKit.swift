import Foundation
#if canImport(UIKit)
import UIKit

public final class NText: UILabel {
    
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
            to: \.text,
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
            to: \.attributedText,
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
        multiline: Bool = false
    ) {
        super.init(frame: .zero)
        
        self.textAlignment = alignment
        self.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
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
        Mirror(self, children: ["text": text])
    }
}
#else
extension NText: @preconcurrency CustomReflectable {
    public var customMirror: Mirror {
        Mirror(self, children: ["text": text])
    }
}
#endif
#endif

