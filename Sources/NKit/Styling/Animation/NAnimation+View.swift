import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

private enum _CurrentAnimation {
    case animation(NAnimation)
    case noAnimation
    
    init(_ animation: NAnimation?) {
        if let animation {
            self = .animation(animation)
        } else {
            self = .noAnimation
        }
    }
    
    var unwrap: NAnimation? {
        switch self {
        case .animation(let animation):
            return animation
        case .noAnimation:
            return nil
        }
    }
}

extension AssociatedId where Value == _CurrentAnimation {
    fileprivate static let currentAnimation = AssociatedId(key: "currentAnimation")
}

extension _View {
    
    public var currentAnimation: NAnimation? {
        guard let global: NAnimation = .current else {
            return nil
        }
        guard let onView: _CurrentAnimation = self[associatedId: .currentAnimation] else {
            return global
        }
        return onView.unwrap
    }
    
    public func animation(_ animation: NAnimation?) -> Self {
        self[associatedId: .currentAnimation] = .init(animation)
        return self
    }
}

#if canImport(AppKit)
extension NSView {
    @inline(__always)
    public func layoutIfNeeded() {
        self.layoutSubtreeIfNeeded()
    }
}
#endif
