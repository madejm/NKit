#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    public func allowsHitTesting(_ enabled: Bool) -> _View {
        self.allowsHitTesting(NGet.constant(enabled))
    }
}

#if canImport(AppKit)
extension NSView {
    public func allowsHitTesting(_ enabled: any NAnyGet<Bool>) -> _View {
        AllowsHitTestingView(enabled: enabled, content: self)
    }
}
#endif

#if canImport(UIKit)
extension UIView {
    public func allowsHitTesting(_ enabled: any NAnyGet<Bool>) -> _View {
        self.userInteractionEnabled = enabled.wrappedValue
        
        enabled.onChange { [weak self] in
            self?.userInteractionEnabled = $0
        }
        
        return self
    }
}
#endif

#if canImport(AppKit)
private final class AllowsHitTestingView: BaseView {
    private let enabled: any NAnyGet<Bool>
    
    init(
        enabled: any NAnyGet<Bool>,
        content: _View
    ) {
        self.enabled = enabled
        super.init()
        self.addSubviewAutomatically(content)
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if enabled.wrappedValue {
            return super.hitTest(point)
        } else {
            return nil
        }
    }
}
#endif
