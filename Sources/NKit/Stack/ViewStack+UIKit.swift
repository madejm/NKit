import Foundation
#if canImport(UIKit)
import UIKit

public class ViewStack: BaseView {
    internal let stack: UIStackView
    internal let content: ViewCreator
    
    internal init(
        alignment: BaseAlignment,
        orientation: Orientation,
        spacing: CGFloat,   
        stretching: Stretching,
        @NViewBuilder content: @escaping ViewCreator
    ) {
        self.content = content
        self.stack = UIStackView()
        
        super.init()
        
        self.stack.alignment = alignment
        self.stack.axis = orientation
        self.stack.spacing = spacing
        
        self.buildContent()
        
        switch orientation {
        case .horizontal:
            switch stretching {
            case .none:
                self.stack.setContentHuggingPriority(.required, for: .horizontal)
                self.stack.setContentHuggingPriority(.sceneSizeStayPut, for: .vertical)
            case .horizontal:
                self.stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
                self.stack.setContentHuggingPriority(.sceneSizeStayPut, for: .vertical)
            case .vertical:
                self.stack.setContentHuggingPriority(.required, for: .horizontal)
                self.stack.setContentHuggingPriority(.defaultLow, for: .vertical)
            case .all:
                self.stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
                self.stack.setContentHuggingPriority(.defaultLow, for: .vertical)
            }
        case .vertical:
            switch stretching {
            case .none:
                self.stack.setContentHuggingPriority(.sceneSizeStayPut, for: .horizontal)
                self.stack.setContentHuggingPriority(.required, for: .vertical)
            case .horizontal:
                self.stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
                self.stack.setContentHuggingPriority(.required, for: .vertical)
            case .vertical:
                self.stack.setContentHuggingPriority(.sceneSizeStayPut, for: .horizontal)
                self.stack.setContentHuggingPriority(.defaultLow, for: .vertical)
            case .all:
                self.stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
                self.stack.setContentHuggingPriority(.defaultLow, for: .vertical)
            }
        @unknown default:
            break
        }
        
        self.prepare()
        self.setupSubviews()
    }
    
    private func setupSubviews() {
        self.addSubviewAutomatically(self.stack)
    }
}
#endif
