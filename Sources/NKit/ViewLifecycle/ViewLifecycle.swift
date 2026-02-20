import Foundation
import Combine
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    private func newParentPublisher() -> AnyPublisher<_ViewParentMessage, Never> {
        if let parent: _ViewController = self.getParent() {
            return Just(.parent(parent)).eraseToAnyPublisher()
        } else {
            return self.parentPublisher.eraseToAnyPublisher()
        }
    }
    
    public func onAppear(
        perform action: @escaping () -> Void
    ) -> Self {
        var currentLifecycle: _ViewController.Lifecycle = .initialized
        
        self.newParentPublisher()
            .removeDuplicates()
            .sink { [unowned self] parent in
                switch parent {
                case .parent(let viewController):
                    currentLifecycle = viewController.lifecycle
                    
                    if viewController.lifecycle >= .didAppear {
                        action()
                    } else {
                        viewController.viewDidAppearPublisher
                            .first()
                            .sink {
                                currentLifecycle = viewController.lifecycle
                                
                                action()
                            }
                            .store(in: &cancellables)
                    }
                case .removed:
                    break
                case .noParent:
                    break
                }
            }
            .store(in: &cancellables)
        
        return self
    }
    
    public func onDisappear(
        perform action: @escaping () -> Void
    ) -> Self {
        var currentLifecycle: _ViewController.Lifecycle = .initialized
        
        self.newParentPublisher()
            .removeDuplicates()
            .sink { [unowned self] parent in
                switch parent {
                case .parent(let viewController):
                    currentLifecycle = viewController.lifecycle
                    
                    if viewController.lifecycle >= .willDisappear {
                        action()
                    } else {
                        viewController.viewWillDisappearPublisher
                            .first()
                            .sink {
                                currentLifecycle = viewController.lifecycle
                                
                                action()
                            }
                            .store(in: &cancellables)
                    }
                case .removed:
                    if currentLifecycle < .willDisappear {
                        action()
                    }
                case .noParent:
                    break
                }
            }
            .store(in: &cancellables)
        
        return self
    }
}

private final class _ViewParent {
    private(set) /*weak*/ var parent: _ViewController?
    let isRootView: Bool
    
    init(
        _ parent: _ViewController,
        isRootView: Bool
    ) {
        self.parent = parent
        self.isRootView = isRootView
    }
}

private enum _ViewParentMessage: Equatable {
    case parent(_ViewController)
    case removed
    case noParent
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.parent(lhsp), .parent(rhsp)):
            return lhsp === rhsp
        case (.removed, .removed):
            return true
        case (.noParent, .noParent):
            return true
        default:
            return false
        }
    }
}

extension AssociatedId where Value == _ViewParent {
    fileprivate static let viewParent: Self = .init(key: "viewParent")
}

extension AssociatedId where Value == PassthroughSubject<_ViewParentMessage, Never> {
    fileprivate static let onParent: Self = .init(key: "onParent")
}

extension AssociatedId where Value == Int {
    fileprivate static let skipParentChanges: Self = .init(key: "skipParentChanges")
}

extension _View {
    fileprivate var parentPublisher: AnyPublisher<_ViewParentMessage, Never> {
        return self[associatedId: .onParent].eraseToAnyPublisher()
    }
    
    internal var skipParentChanges: Int {
        get {
            self[associatedId: .skipParentChanges, default: 0]
        }
        set {
            self[associatedId: .skipParentChanges] = newValue
        }
    }
    
    internal func setParent(_ parent: _ViewController?, isRootView: Bool) {
        if type(of: parent) == _ViewController.self {
            fatalError("\(type(of: parent))")
        }
        
        guard self.skipParentChanges == 0 else {
            self.skipParentChanges -= 1
            return
        }
        
        let oldParent: _ViewParent? = self[associatedId: .viewParent]
        
        guard oldParent?.parent != parent else {
            return
        }
        if let oldParent, parent != nil, oldParent.isRootView {
            // dont override parent, this new parent is probably some superview controller
            return
        }
        
//        print("SET PARENT \(parent.debugDescription) root \(isRootView) ON \(self.debugDescription)")
        
        let message: _ViewParentMessage
        
        if let parent {
            self[associatedId: .viewParent] = _ViewParent(parent, isRootView: isRootView)
            
            message = .parent(parent)
        } else {
            self[associatedId: .viewParent] = nil
            
            if oldParent != nil {
                message = .removed
            } else {
                message = .noParent
            }
        }
        
        for view in subviews {
            view.setParent(parent, isRootView: false)
        }
        
        self[associatedId: .onParent].send(message)
    }
    
    internal func getParent() -> _ViewController? {
        self[associatedId: .viewParent]?.parent
    }
}
