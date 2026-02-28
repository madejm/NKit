import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

internal final class _StackView: _Stack {
    private var fitConstraints: [ObjectIdentifier: NSLayoutConstraint] = [:]
    private var distributionConstraints: [NSLayoutConstraint] = []
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func addArrangedSubview(_ view: _View) {
        super.addArrangedSubview(view)
        
        #if canImport(UIKit)
        updateFitConstraint(view)
        #endif
    }
    
    public override func insertArrangedSubview(_ view: _View, at index: Int) {
        super.insertArrangedSubview(view, at: index)
        
        updateFitConstraint(view)
    }
    
    public override func removeArrangedSubview(_ view: _View) {
        super.removeArrangedSubview(view)
        
        fitConstraints[ObjectIdentifier(view)]?.isActive = false
        fitConstraints[ObjectIdentifier(view)] = nil
    }
}

extension _StackView {
    fileprivate func getDimmension() -> NDimmension? {
        switch orientation {
        case .horizontal:
            return .width
        case .vertical:
            return .height
        @unknown default:
            return nil
        }
    }
    
    fileprivate func getLayoutDirection() -> NLayoutDirection? {
        switch orientation {
        case .horizontal:
            return .horizontal
        case .vertical:
            return .vertical
        @unknown default:
            return nil
        }
    }
}

extension _StackView {
    fileprivate func updateFitConstraint(_ view: _View) {
        fitConstraints[ObjectIdentifier(view)]?.isActive = false
        
        guard let dimmension: NDimmension = getDimmension()?.opposite,
              let layoutDirection: NLayoutDirection = getLayoutDirection()
        else {
            return
        }
        
        let constraint: NSLayoutConstraint = dimmension.constraint(superview: self, subview: view, priority: NKitDefaults.stackFitLayoutPriority).activate()
        fitConstraints[ObjectIdentifier(view)] = constraint
        
        view.setLayoutDirection(layoutDirection)
    }
    
    internal func updateDimmensionConstraints() {
        NSLayoutConstraint.deactivate(distributionConstraints)
        
        guard let dimmension: NDimmension = getDimmension() else {
            return
        }
        
        distributionConstraints = self.arrangedSubviews.indices.flatMap { index in
            guard index < self.arrangedSubviews.count - 1 else {
                return Array<NSLayoutConstraint>()
            }
            return ((index + 1)..<self.arrangedSubviews.count).map { subIndex in
                dimmension.constraint(
                    superview: self.arrangedSubviews[index],
                    subview: self.arrangedSubviews[subIndex],
                    multiplier: 1,
                    value: 0,
                    priority: NKitDefaults.stackDimmensionLayoutPriority
                )
            }
        }
        NSLayoutConstraint.activate(distributionConstraints)
    }
}

extension NDimmension {
    fileprivate var opposite: NDimmension {
        switch self {
        case .width:  .height
        case .height: .width
        }
    }
}
