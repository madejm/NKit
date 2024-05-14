import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    public func hidden(_ hidden: Bool) -> Self {
        self.hidden(NGet.constant(hidden))
    }
    
    public func hidden(_ hiddenBinding: NBinding<Bool>) -> Self {
        self.hidden(hiddenBinding.get)
    }
    
    public func hidden(_ hiddenBinding: NGet<Bool>) -> Self {
        let initialValue: Bool = hiddenBinding.wrappedValue
        
        OperationQueue.main.addOperation { [weak self] in
            self?.firstViewInStack?.isHidden = initialValue
        }
        
        hiddenBinding.onChange { [weak self] newValue in
            self?.firstViewInStack?.isHidden = newValue
        }
        
        return self
    }
    
    private var firstViewInStack: _View? {
        guard let parent: _View = self.superview else {
            return nil
        }
        
        if let parentOverlay = parent as? NOverlay,
           parentOverlay.mainView != self {
            return self
        }
        guard let parentStack = parent as? _Stack else {
            return parent.firstViewInStack
        }
        guard parentStack.arrangedSubviews.count > 1 else {
            return parent.firstViewInStack
        }
        return self
    }
}

