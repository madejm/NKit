import Foundation

@MainActor
internal protocol Changeable {
    func onAnyChange(_ new: @escaping @MainActor() -> Void)
}

extension NBinding: Changeable {
    internal func onAnyChange(_ new: @escaping @MainActor () -> Void) {
        self.onChange { _ in
            new()
        }
    }
}

extension NGet: Changeable {
    internal func onAnyChange(_ new: @escaping @MainActor () -> Void) {
        self.onChange { _ in
            new()
        }
    }
}
