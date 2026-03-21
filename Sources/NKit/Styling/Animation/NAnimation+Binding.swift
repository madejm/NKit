import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@MainActor
public protocol _Bindable {
}

extension _View: _Bindable {
}

extension _Bindable where Self: _View {
    public func bind<Value>(
        _ binding: any NAnyGet<Value>,
        to keyPath: WritableKeyPath<Self, Value?>,
        setInitial: Bool = true,
        animationTransitionType: CATransitionType = .fade,
        additionalUpdates: ((_ newValue: Value) -> Void)? = nil
    ) {
        self.bind(
            binding,
            setInitial: setInitial,
            animationTransitionType: animationTransitionType,
            set: { [weak self] value in
                guard var self else {
                    return
                }
                self[keyPath: keyPath] = value
                additionalUpdates?(value)
            }
        )
    }
    
    public func bind<Value>(
        _ binding: any NAnyGet<Value>,
        to keyPath: WritableKeyPath<Self, Value>,
        setInitial: Bool = true,
        animationTransitionType: CATransitionType = .fade,
        additionalUpdates: ((_ newValue: Value) -> Void)? = nil
    ) {
        self.bind(
            binding,
            setInitial: setInitial,
            animationTransitionType: animationTransitionType,
            set: { [weak self] value in
                guard var self else {
                    return
                }
                self[keyPath: keyPath] = value
                additionalUpdates?(value)
            }
        )
    }
    
    public func bind<Value>(
        _ binding: any NAnyGet<Value>,
        setInitial: Bool = true,
        animationTransitionType: CATransitionType = .fade,
        set setClosure: @escaping (_ value: Value) -> Void
    ) {
        if setInitial {
            let initialValue: Value = binding.wrappedValue
            setClosure(initialValue)
        }
        
        binding.onChange { [weak self] in
            guard var self else {
                return
            }
            
            let animation: NAnimation? = self.currentAnimation
            
            if let animation {
                let transition = CATransition()
                transition.type = animationTransitionType
                transition.duration = animation.duration
                transition.timingFunction = animation.timingFunction
                #if canImport(AppKit)
                self.layer?.add(transition, forKey: kCATransition)
                #elseif canImport(UIKit)
                self.layer.add(transition, forKey: kCATransition)
                #endif
            }
            
            setClosure($0)
            
            if animation != nil {
                self.layoutIfNeeded()
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
