import Foundation
#if canImport(UIKit)
import UIKit

public final class NText: UILabel {
    @NGet private var textBinding: NSAttributedString
    
    #if DEBUG
    nonisolated(unsafe) internal var debugStringValue: String
    #endif
    
    public init(
        _ textBinding: NGet<NSAttributedString>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = false
    ) {
        self._textBinding = textBinding
        
        #if DEBUG
        self.debugStringValue = textBinding.wrappedValue.string
        #endif
        
        super.init(frame: .zero)
        
        self.attributedText = textBinding.wrappedValue
        self.textAlignment = alignment
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        
        self._textBinding.onChange { [weak self] in
            self?.attributedText = $0
            
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

