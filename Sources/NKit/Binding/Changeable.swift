import Foundation

internal protocol Changeable {
    func onAnyChange(_ new: @escaping () -> Void)
}

extension NBinding: Changeable {
    internal func onAnyChange(_ new: @escaping () -> Void) {
        self.onChange { _ in
            new()
        }
    }
}

extension NGet: Changeable {
    internal func onAnyChange(_ new: @escaping () -> Void) {
        self.onChange { _ in
            new()
        }
    }
}
