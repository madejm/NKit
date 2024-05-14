import Foundation
#if canImport(AppKit)
import AppKit

extension NSResponder: NOwner {}

extension NOwner {
    internal func propagateToChildren<V: Equatable>(
        value: V,
        key: KeyPath<NEnvironmentValues, V>
    ) {
        if let viewController = self as? NSViewController {
            let view: NSView = viewController.view
            
            if !view.setEnvironment(value: value, key: key) {
                view.propagateToChildren(value: value, key: key)
            }
        } else if let view = self as? NSView {
            view.subviews
                .forEach {
                    if !$0.setEnvironment(value: value, key: key) {
                        $0.propagateToChildren(value: value, key: key)
                    }
                }
        }
    }
}
#endif
