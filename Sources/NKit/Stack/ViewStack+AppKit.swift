import Foundation
#if canImport(AppKit)
import AppKit

public class ViewStack: BaseView {
    internal let stack: NSStackView
    internal let content: ViewCreator
    
    internal init(
        alignment: BaseAlignment,
        orientation: Orientation,
        spacing: CGFloat,
        stretching: Stretching,
        @NViewBuilder content: @escaping ViewCreator
    ) {
        self.content = content
        self.stack = NSStackView()
        
        super.init()
        
        self.stack.alignment = alignment
        self.stack.orientation = orientation
        self.stack.spacing = spacing
        
        self.buildContent()
        
        switch orientation {
        case .horizontal:
            switch stretching {
            case .none:
                self.stack.setHuggingPriority(.required, for: .horizontal)
                self.stack.setHuggingPriority(.windowSizeStayPut, for: .vertical)
            case .horizontal:
                self.stack.setHuggingPriority(.defaultLow, for: .horizontal)
                self.stack.setHuggingPriority(.windowSizeStayPut, for: .vertical)
            case .vertical:
                self.stack.setHuggingPriority(.required, for: .horizontal)
                self.stack.setHuggingPriority(.defaultLow, for: .vertical)
            case .all:
                self.stack.setHuggingPriority(.defaultLow, for: .horizontal)
                self.stack.setHuggingPriority(.defaultLow, for: .vertical)
            }
        case .vertical:
            switch stretching {
            case .none:
                self.stack.setHuggingPriority(.windowSizeStayPut, for: .horizontal)
                self.stack.setHuggingPriority(.required, for: .vertical)
            case .horizontal:
                self.stack.setHuggingPriority(.defaultLow, for: .horizontal)
                self.stack.setHuggingPriority(.required, for: .vertical)
            case .vertical:
                self.stack.setHuggingPriority(.windowSizeStayPut, for: .horizontal)
                self.stack.setHuggingPriority(.defaultLow, for: .vertical)
            case .all:
                self.stack.setHuggingPriority(.defaultLow, for: .horizontal)
                self.stack.setHuggingPriority(.defaultLow, for: .vertical)
            }
        @unknown default:
            break
        }
        
        self.prepare()
        self.setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupSubviews() {
        self.addSubviewAutomatically(self.stack)
    }
}
#endif
