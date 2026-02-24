import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NStepper where V: BinaryInteger {
    
    public convenience init(
        _ valueBinding: NBinding<V>,
        range: ClosedRange<V>? = nil,
        step: V = 1,
        autorepeat: Bool = true,
        wraps: Bool = false
    ) {
        self.init(
            valueBinding,
            range: range,
            step: step,
            autorepeat: autorepeat,
            wraps: wraps,
            castUp: { V($0) },
            castDown: { Double($0) }
        )
        
    }
    
    public convenience init(
        _ value: V,
        range: ClosedRange<V>? = nil,
        step: V = 1,
        autorepeat: Bool = true,
        wraps: Bool = false
    ) {
        self.init(
            .constant(value),
            range: range,
            step: step,
            autorepeat: autorepeat,
            wraps: wraps
        )
    }
}

extension NStepper where V: BinaryFloatingPoint {
    
    public convenience init(
        _ valueBinding: NBinding<V>,
        range: ClosedRange<V>? = nil,
        step: V = 1,
        autorepeat: Bool = true,
        wraps: Bool = false
    ) {
        self.init(
            valueBinding,
            range: range,
            step: step,
            autorepeat: autorepeat,
            wraps: wraps,
            castUp: { V($0) },
            castDown: { Double($0) }
        )
        
    }
    
    public convenience init(
        _ value: V,
        range: ClosedRange<V>? = nil,
        step: V = 1,
        autorepeat: Bool = true,
        wraps: Bool = false
    ) {
        self.init(
            .constant(value),
            range: range,
            step: step,
            autorepeat: autorepeat,
            wraps: wraps
        )
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState<Double> var value1 = 0
    @Previewable @NState<Double> var value2 = 0
    
    var value1Int: NBinding<Int> = $value1.map(
        up: { Int($0) },
        down: { Double($0) }
    )
    var value2Int: NBinding<Int> = $value2.map(
        up: { Int($0) },
        down: { Double($0) }
    )
    
    NViewPreview {
        NVStack(alignment: .center, spacing: 8) {
            NHStack(alignment: .center, spacing: 8) {
                NText($value1.get.map(up: { "\($0)" }))
                NStepper(
                    $value1,
                    step: 1,
                    autorepeat: true,
                    wraps: false
                )
                NStepper(
                    value1Int,
                    step: 1,
                    autorepeat: true,
                    wraps: false
                )
            }
            NHStack(alignment: .center, spacing: 8) {
                NText($value2.get.map(up: { "\($0)" }))
                NStepper(
                    $value2,
                    range: 0...6,
                    step: 2.5,
                    autorepeat: false,
                    wraps: true
                )
                NStepper(
                    value2Int,
                    range: 0...6,
                    step: 2,
                    autorepeat: false,
                    wraps: true
                )
            }
        }
        .frame(width: 300)
        .padding(8)
    }
}
#endif
