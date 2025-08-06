import Foundation

@MainActor
internal protocol Changeable {
    func onAnyChange(_ new: @escaping @MainActor() -> Void)
}

extension NAnyGet where Self: Changeable {
    internal func onAnyChange(_ new: @escaping @MainActor () -> Void) {
        self.onChange { _ in
            new()
        }
    }
}

extension NGet: Changeable {}
extension NBinding: Changeable {}
extension NState: Changeable {}
