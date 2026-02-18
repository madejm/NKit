import Foundation
#if canImport(AppKit)
import AppKit

open class NSlider: NSSlider {
    @NBinding fileprivate var valueBinding: Int
    
    public init(
        minValue: Double? = nil,
        maxValue: Double? = nil,
        numberOfTickMarks: Int? = nil,
        sliderType: NSSlider.SliderType = .linear,
        isVertical: Bool = false,
        _ valueBinding: NBinding<Int>
    ) {
        self._valueBinding = valueBinding
        
        super.init(frame: .zero)
        
        if let minValue {
            self.minValue = minValue
        }
        if let maxValue {
            self.maxValue = maxValue
        }
        if let numberOfTickMarks {
            self.numberOfTickMarks = numberOfTickMarks
        }
        
        self.sliderType = sliderType
        self.isVertical = isVertical
        
        self.target = self
        self.action = #selector(valueChanged)
        
        self.integerValue = valueBinding.wrappedValue
        
        self._valueBinding.onChange {
            self.integerValue = $0
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func valueChanged() {
        valueBinding = integerValue
    }
}
#endif
