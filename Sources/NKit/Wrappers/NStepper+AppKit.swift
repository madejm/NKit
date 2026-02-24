import Foundation
#if canImport(AppKit)
import AppKit

open class NStepper<V>: NSStepper where V: Equatable, V: Comparable {
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
            self.minValue = castDown(range.lowerBound)
            self.maxValue = castDown(range.upperBound)
        }
        
        self.doubleValue = castDown(valueBinding.wrappedValue)
        self.increment = castDown(step)
        self.autorepeat = autorepeat
        self.valueWraps = wraps
        self.target = self
        self.action = #selector(onStepperChange)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self._valueBinding.onChange { [weak self] in
            guard let self else {
                return
            }
            self.doubleValue = self.castDown($0)
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func onStepperChange() {
        self.valueBinding = self.castUp(self.doubleValue)
    }
}
#endif
