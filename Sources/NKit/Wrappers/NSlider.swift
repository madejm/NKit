import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

public enum NSliderStyle {
    case linear
    case circular
    
    #if canImport(AppKit)
    var sliderType: NSSlider.SliderType {
        switch self {
        case .linear:   .linear
        case .circular: .circular
        }
    }
    #endif
}

extension NSlider {
    public func sliderStyle(_ style: NGet<NSliderStyle>) -> Self {
        #if canImport(AppKit)
        bind(style.sliderType, to: \.sliderType)
        #endif
        return self
    }
    
    public func sliderStyle(_ style: NSliderStyle) -> Self {
        #if canImport(AppKit)
        self.sliderType = style.sliderType
        #endif
        return self
    }
    
    public func sliderVertical(_ vertical: NGet<Bool>) -> Self {
        #if canImport(AppKit)
        bind(vertical, to: \.isVertical)
        #endif
        return self
    }
    
    public func sliderVertical(_ vertical: Bool) -> Self {
        #if canImport(AppKit)
        self.isVertical = vertical
        #endif
        return self
    }
    
    public func sliderTickMarks(_ numberOfTickMarks: NGet<Int>) -> Self {
        #if canImport(AppKit)
        bind(numberOfTickMarks, to: \.numberOfTickMarks)
        #endif
        return self
    }
    
    public func sliderTickMarks(_ numberOfTickMarks: Int) -> Self {
        #if canImport(AppKit)
        self.numberOfTickMarks = numberOfTickMarks
        #endif
        return self
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState<Double> var value = 50
    
    NViewPreview {
        NVStack(alignment: .center, spacing: 8) {
            NSlider(
                minValue: 0,
                maxValue: 100,
                $value
            )
            .sliderStyle(.linear)
            
            NSlider(
                minValue: 0,
                maxValue: 100,
                $value
            )
            .sliderStyle(.circular)
        }
        .frame(width: 300)
        .padding(8)
    }
}
#endif
