import Foundation
#if canImport(UIKit)
import UIKit

extension UIResponder: NOwner {}

extension NOwner {
    internal func propagateToChildren<V: Equatable>(
        value: V,
        key: KeyPath<NEnvironmentValues, V>
    ) {
        if let viewController = self as? UIViewController {
            let view: UIView = viewController.view
            
            if !view.setEnvironment(value: value, key: key) {
                view.propagateToChildren(value: value, key: key)
            }
        } else if let view = self as? UIView {
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
