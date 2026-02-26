import Foundation
#if canImport(AppKit)
import AppKit

open class NLinearGradient: NSView {
    
    private var gradient: CAGradientLayer? {
        layer as? CAGradientLayer
    }
    
    internal init(
        colors: NGet<[_Color]>,
        locations: NGet<[CGFloat]>?,
        startPoint: NGet<NLinearGradient.UnitPoint>,
        endPoint: NGet<NLinearGradient.UnitPoint>
    ) {
        super.init(frame: .zero)
        
        let gradient = CAGradientLayer()
        self.layer = gradient
        
        gradient.colors = colors
            .wrappedValue
            .map { color in
                color.cgColor
            }
        gradient.startPoint = startPoint.wrappedValue.point
        gradient.endPoint = endPoint.wrappedValue.point
        gradient.locations = locations?.wrappedValue.map { location in
            NSNumber(value: location)
        }
        
        colors.onChange { [weak self] in
            self?.gradient?.colors = $0
                .map { color in
                    color.cgColor
                }
        }
        startPoint.onChange { [weak self] in
            self?.gradient?.startPoint = $0.point
        }
        endPoint.onChange { [weak self] in
            self?.gradient?.endPoint = $0.point
        }
        locations?.onChange { [weak self] in
            self?.gradient?.locations = $0.map { location in
                NSNumber(value: location)
            }
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
