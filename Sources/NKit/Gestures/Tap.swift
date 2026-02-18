import Foundation
#if canImport(AppKit)
import AppKit

@MainActor
private final class GestureHandler {
    internal let callback: () -> Void
    
    internal init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    @objc
    internal func fire() {
        callback()
    }
}

extension AssociatedId where Value == GestureHandler {
    fileprivate static let gestureHandler: Self = .init(key: "gestureHandler")
}

extension _View {
    public func onTapGesture(
        count: Int = 1,
        action: @escaping () -> Void
    ) -> Self {
        let gestureHandler = GestureHandler(callback: action)
        
        let gesture = NSClickGestureRecognizer()
        gesture.numberOfClicksRequired = count
        gesture.target = gestureHandler
        gesture.action = #selector(GestureHandler.fire)
        
        self[associatedId: .gestureHandler] = gestureHandler
        
        self.addGestureRecognizer(gesture)
        
        return self
    }
}
#endif
