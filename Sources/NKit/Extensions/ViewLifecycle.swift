import Foundation
import Combine
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    private func onNewParent(
        perform action: @escaping (_ViewParentMessage) -> Void
    ) {
        if let parent: _ViewController = self.getParent() {
            action(.parent(parent))
        } else {
            self.parentPublisher
                .sink { parent in
                    action(parent)
                }
                .store(in: &cancellables)
        }
    }
    
    public func onAppear(
        perform action: @escaping () -> Void
    ) -> Self {
        self.onNewParent { [unowned self] parent in
            switch parent {
            case .parent(let viewController):
                if viewController.lifecycle >= .didAppear {
                    action()
                } else {
                    viewController.viewDidAppearPublisher
                        .first()
                        .sink {
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
        
        return self
    }
    
    public func onDisappear(
        perform action: @escaping () -> Void
    ) -> Self {
        self.onNewParent { [unowned self] parent in
            switch parent {
            case .parent(let viewController):
                if viewController.lifecycle >= .willDisappear {
                    action()
                } else {
                    viewController.viewWillDisappearPublisher
                        .first()
                        .sink {
                            action()
                        }
                        .store(in: &cancellables)
                }
            case .removed:
                action()
            case .noParent:
                break
            }
        }
        
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

private enum _ViewParentMessage {
    case parent(_ViewController)
    case removed
    case noParent
}

extension AssociatedId where Value == _ViewParent {
    fileprivate static let viewParent: Self = .init(key: "viewParent")
}

extension AssociatedId where Value == PassthroughSubject<_ViewParentMessage, Never> {
    fileprivate static let onParent: Self = .init(key: "onParent")
}

extension _View {
    fileprivate var parentPublisher: AnyPublisher<_ViewParentMessage, Never> {
        return self[associatedId: .onParent].eraseToAnyPublisher()
    }
    
    internal func setParent(_ parent: _ViewController?, isRootView: Bool) {
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
