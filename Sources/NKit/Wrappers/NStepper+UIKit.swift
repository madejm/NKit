import Foundation
#if canImport(UIKit)
import UIKit

open class NStepper<V>: UIStepper where V: Equatable, V: Comparable {
    @NBinding private var valueBinding: V
    private let castUp: (Double) -> V
    private let castDown: (V) -> Double
    
    internal init(
        _ valueBinding: NBinding<V>,
        range: ClosedRange<V>?,
        step: V,
        autorepeat: Bool,
        wraps: Bool,
        castUp: @escaping (Double) -> V,
        castDown: @escaping (V) -> Double
    ) {
        self._valueBinding = valueBinding
        self.castUp = castUp
        self.castDown = castDown
        
        super.init(frame: .zero)
        
        if let range {
            self.minimumValue = castDown(range.lowerBound)
            self.maximumValue = castDown(range.upperBound)
        }
        
        self.value = castDown(valueBinding.wrappedValue)
        self.stepValue = castDown(step)
        self.autorepeat = autorepeat
        self.wraps = wraps
        self.addTarget(self, action: #selector(onStepperChange), for: .valueChanged)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self._valueBinding.onChange { [weak self] in
            guard let self else {
                return
            }
            self.value = self.castDown($0)
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func onStepperChange() {
        self.valueBinding = self.castUp(self.value)
    }
}
#endif
