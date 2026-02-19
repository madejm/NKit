import Foundation
import Combine

extension AssociatedId where Value == Set<AnyCancellable> {
    internal static let cancellables: Self = .init(key: "cancellables")
}

extension Set<AnyCancellable>: AssociatedIdDefaultable {
    static var defaultValue: Set<Element> {
        []
    }
}

extension NSObject {
    
    @MainActor
    internal var cancellables: Set<AnyCancellable> {
        get {
            self[associatedId: .cancellables]
        }
        set {
            self[associatedId: .cancellables] = newValue
        }
    }
}
