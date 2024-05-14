import Foundation
#if canImport(AppKit)
import AppKit

open class Stepper: NSStepper {
    @NBinding private var valueBinding: Int
    
    public convenience init(
        _ value: Int,
        range: ClosedRange<Int>?
    ) {
        self.init(.constant(value), range: range)
    }
    
    public init(
        _ valueBinding: NBinding<Int>,
        range: ClosedRange<Int>?
    ) {
        self._valueBinding = valueBinding
        
        super.init(frame: .zero)
        
        if let range = range {
            self.minValue = Double(range.lowerBound)
            self.maxValue = Double(range.upperBound)
        }
        
        self.integerValue = valueBinding.wrappedValue
        self.target = self
        self.action = #selector(onStepperChange)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self._valueBinding.onChange {
            self.integerValue = $0
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func onStepperChange() {
        self.valueBinding = self.integerValue
    }
}
#endif
