import Foundation

@MainActor
internal protocol Changeable {
    func onAnyChange(_ new: @escaping @MainActor() -> Void)
    func onSomeChange(_ new: @escaping @MainActor(Any) -> Void)
}

extension NAnyGet where Self: Changeable {
    internal func onAnyChange(_ new: @escaping @MainActor () -> Void) {
        self.onChange { _ in
            new()
        }
    }
    
    internal func onSomeChange(_ new: @escaping @MainActor (Any) -> Void) {
        self.onChange {
            new($0)
        }
    }
}

extension NGet: Changeable {}
extension NBinding: Changeable {}
extension NState: Changeable {}
