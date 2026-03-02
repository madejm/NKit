import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NAnyGet {
    public func updating<View>(
        view: View,
        keyPath: WritableKeyPath<View, Value?>,
        setInitial: Bool = true,
        animationTransitionType: CATransitionType = .fade,
        additionalUpdates: ((_ view: View, _ newValue: Value) -> Void)? = nil
    ) where View: _View {
        self.updating(
            view: view,
            setInitial: setInitial,
            animationTransitionType: animationTransitionType,
            set: { view, value in
                var copy = view
                copy[keyPath: keyPath] = value
                additionalUpdates?(view, value)
            }
        )
    }
    
    public func updating<View>(
        view: View,
        keyPath: WritableKeyPath<View, Value>,
        setInitial: Bool = true,
        animationTransitionType: CATransitionType = .fade,
        additionalUpdates: ((_ view: View, _ newValue: Value) -> Void)? = nil
    ) where View: _View {
        self.updating(
            view: view,
            setInitial: setInitial,
            animationTransitionType: animationTransitionType,
            set: { view, value in
                var copy = view
                copy[keyPath: keyPath] = value
                additionalUpdates?(view, value)
            }
        )
    }
    
    public func updating<View>(
        view: View,
        setInitial: Bool = true,
        animationTransitionType: CATransitionType = .fade,
        set setClosure: @escaping (_ view: View, _ value: Value) -> Void
    ) where View: _View {
        if setInitial {
            let initialValue: Value = self.wrappedValue
            setClosure(view, initialValue)
        }
        
        self.onChange { [weak view] in
            guard var view else {
                return
            }
            
            let animation: NAnimation? = view.currentAnimation
            
            if let animation {
                let transition = CATransition()
                transition.type = animationTransitionType
                transition.duration = animation.duration
                transition.timingFunction = animation.timingFunction
                #if canImport(AppKit)
                view.layer?.add(transition, forKey: kCATransition)
                #elseif canImport(UIKit)
                view.layer.add(transition, forKey: kCATransition)
                #endif
            }
            
            setClosure(view, $0)
            
            if animation != nil {
                view.layoutIfNeeded()
            }
        }
    }
}

extension NBinding {
    public func setsAnimation(_ animation: NAnimation = .default) -> NBinding<Value> {
        let newBinding: NBinding<Value> = .init(get: {
            self.wrappedValue
        }, set: { newValue in
            nWithAnimation(animation) {
                self.wrappedValue = newValue
            }
        })
        
        self.onChange { newValue in
            newBinding.wrappedValue = newValue
        }
        newBinding.onChange { [weak self] newValue in
            self?.wrappedValue = newValue
        }
        
        return newBinding
    }
}
