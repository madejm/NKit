import Foundation
import Combine
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension AssociatedId where Value == PassthroughSubject<Void, Never> {
    internal static let viewWillMoveToSuperviewId: Self = .init(key: "viewWillMoveToSuperview")
    internal static let viewDidMoveToSuperviewId: Self = .init(key: "viewDidMoveToSuperview")
    internal static let viewWillMoveToWindowId: Self = .init(key: "viewWillMoveToWindow")
    internal static let removeFromSuperviewId: Self = .init(key: "removeFromSuperview")
}

extension _View {
    internal var viewWillMoveToSuperviewPublisher: AnyPublisher<Void, Never> {
        self[associatedId: .viewWillMoveToSuperviewId].eraseToAnyPublisher()
    }
    internal var viewDidMoveToSuperviewPublisher: AnyPublisher<Void, Never> {
        self[associatedId: .viewDidMoveToSuperviewId].eraseToAnyPublisher()
    }
    internal var viewWillMoveToWindowPublisher: AnyPublisher<Void, Never> {
        self[associatedId: .viewWillMoveToWindowId].eraseToAnyPublisher()
    }
    internal var removeFromSuperviewPublisher: AnyPublisher<Void, Never> {
        self[associatedId: .removeFromSuperviewId].eraseToAnyPublisher()
    }
}
