import Foundation
import Combine
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension AssociatedId where Value == _ViewController.Lifecycle {
    internal static let viewControllerLifecycle: Self = .init(key: "viewControllerLifecycle")
}

extension AssociatedId where Value == PassthroughSubject<Void, Never> {
    internal static let viewWillAppearId: Self = .init(key: "viewWillAppear")
    internal static let viewDidAppearId: Self = .init(key: "viewDidAppear")
    internal static let viewWillDisappearId: Self = .init(key: "viewWillDisappear")
    internal static let viewDidDisappearId: Self = .init(key: "viewDidDisappear")
}

extension _ViewController {
    internal enum Lifecycle: AssociatedIdDefaultable, Comparable {
        static let defaultValue: Lifecycle = .initialized
        
        case initialized
        case didLoad
        case willAppear
        case didAppear
        case willDisappear
        case didDisappear
    }
    
    internal var lifecycle: Lifecycle {
        self[associatedId: .viewControllerLifecycle]
    }
}

extension _ViewController {
    internal var viewWillAppearPublisher: AnyPublisher<Void, Never> {
        self[associatedId: .viewWillAppearId].eraseToAnyPublisher()
    }
    internal var viewDidAppearPublisher: AnyPublisher<Void, Never> {
        self[associatedId: .viewDidAppearId].eraseToAnyPublisher()
    }
    internal var viewWillDisappearPublisher: AnyPublisher<Void, Never> {
        self[associatedId: .viewWillDisappearId].eraseToAnyPublisher()
    }
    internal var viewDidDisappearPublisher: AnyPublisher<Void, Never> {
        self[associatedId: .viewDidDisappearId].eraseToAnyPublisher()
    }
}
