import Foundation
#if canImport(UIKit)
import UIKit

open class NSlider: UISlider {
    @NBinding private var valueBinding: Float
    
    public convenience init(
        minValue: Int? = nil,
        maxValue: Int? = nil,
        _ valueBinding: NBinding<Int>
    ) {
        self.init(
            minValue: minValue.map { Float($0) },
            maxValue: maxValue.map { Float($0) },
            valueBinding: valueBinding.map(
                up: { Float($0) },
                down: { Int($0) }
            )
        )
    }
    
    public convenience init<Value: BinaryFloatingPoint>(
        minValue: Value? = nil,
        maxValue: Value? = nil,
        _ valueBinding: NBinding<Value>
    ) {
        self.init(
            minValue: minValue.map { Float($0) },
            maxValue: maxValue.map { Float($0) },
            valueBinding: valueBinding.map(
                up: { Float($0) },
                down: { Value($0) }
            )
        )
    }
    
    private init(
        minValue: Float?,
        maxValue: Float?,
        valueBinding: NBinding<Float>
    ) {
        self._valueBinding = valueBinding
        
        super.init(frame: .zero)
        
        if let minValue {
            self.minimumValue = minValue
        }
        if let maxValue {
            self.maximumValue = maxValue
        }
        
        self.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        bind(valueBinding, to: \.value)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func valueChanged() {
        valueBinding = value
    }
}
#endif
