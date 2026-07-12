import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

public enum NProgressViewStyle {
    case circular
    case linear
    
    #if canImport(AppKit)
    var style: NSProgressIndicator.Style {
        switch self {
        case .circular: .spinning
        case .linear:   .bar
        }
    }
    #endif
}

#if canImport(AppKit)
open class NProgressView: NSProgressIndicator {
    private let valueBinding: NGet<Double>?
    
    public init() {
        self.valueBinding = nil
        
        super.init(frame: .zero)
        
        self.isIndeterminate = true
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        
        startAnimation(nil)
    }
    
    public init<V>(
        value valueBinding: NGet<V>
    ) where V: BinaryFloatingPoint {
        let binding: NGet<Double> = valueBinding.map { Double($0) }
        self.valueBinding = binding
        
        super.init(frame: .zero)
        
        self.isIndeterminate = false
        self.minValue = 0.0
        self.maxValue = 1.0
        
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        
        bind(binding, to: \.doubleValue)
        
        startAnimation(nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#elseif canImport(UIKit)
open class NProgressView: BaseView {
    private let valueBinding: NGet<Float>?
    
    public override init() {
        self.valueBinding = nil
        
        super.init()
        
        let activityIndicatorView = UIActivityIndicatorView(frame: .zero)
        activityIndicatorView.setContentHuggingPriority(.required, for: .horizontal)
        activityIndicatorView.setContentHuggingPriority(.required, for: .vertical)
        activityIndicatorView.startAnimating()
        
        self.addSubviewAutomatically(activityIndicatorView)
    }
    
    public init<V>(
        value valueBinding: NGet<V>
    ) where V: BinaryFloatingPoint {
        let binding: NGet<Float> = valueBinding.map { Float($0) }
        self.valueBinding = binding
        
        super.init()
        
        let progressView = UIProgressView(frame: .zero)
        progressView.setContentHuggingPriority(.required, for: .horizontal)
        progressView.setContentHuggingPriority(.required, for: .vertical)
        progressView.bind(binding, to: \.progress)
        
        self.addSubviewAutomatically(progressView)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

extension NProgressView {
    public func progressViewStyle(_ style: NGet<NProgressViewStyle>) -> Self {
        #if canImport(AppKit)
        bind(style.style, to: \.style)
        #endif
        return self
    }
    
    public func progressViewStyle(_ style: NProgressViewStyle) -> Self {
        #if canImport(AppKit)
        self.style = style.style
        #endif
        return self
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState var value: CGFloat = 0.5
    
    NViewPreview {
        NVStack(spacing: 8) {
            NSlider(
                minValue: 0.0,
                maxValue: 1.0,
                $value
            )
            
            NProgressView(value: $value.get)
                .progressViewStyle(.circular)
            
            NProgressView(value: $value.get)
                .progressViewStyle(.linear)
            
            NProgressView()
                .progressViewStyle(.circular)
            
            NProgressView()
                .progressViewStyle(.linear)
        }
        .frame(width: 200)
        .padding(20)
    }
}
#endif
