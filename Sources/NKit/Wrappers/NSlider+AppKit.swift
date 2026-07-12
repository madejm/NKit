import Foundation
#if canImport(AppKit)
import AppKit

open class NSlider: NSSlider {
    private let intBinding: NBinding<Int>?
    private let doubleBinding: NBinding<Double>?
    
    public convenience init(
        minValue: Int? = nil,
        maxValue: Int? = nil,
        _ valueBinding: NBinding<Int>
    ) {
        self.init(
            minValue: minValue.map { Double($0) },
            maxValue: maxValue.map { Double($0) },
            intBinding: valueBinding,
            doubleBinding: nil
        )
        
        self.integerValue = valueBinding.wrappedValue
        
        valueBinding.onChange {
            self.integerValue = $0
        }
    }
    
    public convenience init<Value: BinaryFloatingPoint>(
        minValue: Value? = nil,
        maxValue: Value? = nil,
        _ valueBinding: NBinding<Value>
    ) {
        let doubleBinding: NBinding<Double> = valueBinding
            .map(
                up: {
                    Double($0)
                },
                down: {
                    Value($0)
                }
            )
        
        self.init(
            minValue: minValue.map { Double($0) },
            maxValue: maxValue.map { Double($0) },
            intBinding: nil,
            doubleBinding: doubleBinding
        )
        
        self.doubleValue = doubleBinding.wrappedValue
        
        doubleBinding.onChange {
            self.doubleValue = $0
        }
    }
    
    private init(
        minValue: Double?,
        maxValue: Double?,
        intBinding: NBinding<Int>?,
        doubleBinding: NBinding<Double>?
    ) {
        self.intBinding = intBinding
        self.doubleBinding = doubleBinding
        
        super.init(frame: .zero)
        
        if let minValue {
            self.minValue = minValue
        }
        if let maxValue {
            self.maxValue = maxValue
        }
        
        self.target = self
        self.action = #selector(valueChanged)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func valueChanged() {
        intBinding?.wrappedValue = integerValue
        doubleBinding?.wrappedValue = doubleValue
    }
}
#endif
