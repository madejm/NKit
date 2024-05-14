import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public final class NColor: BaseView {
    @NGet private var colorBinding: _Color
    
    public convenience init(_ color: _Color) {
        self.init(NGet.constant(color))
    }
    
    public convenience init(_ colorBinding: NBinding<_Color>) {
        self.init(colorBinding.get)
    }
    
    public init(_ colorBinding: NGet<_Color>) {
        self._colorBinding = colorBinding
        
        super.init()
        
        self.setBackgroundColor(colorBinding.wrappedValue)
        
        colorBinding.onChange { [weak self] newColor in
            self?.setBackgroundColor(newColor)
        }
    }
    
    private func setBackgroundColor(_ color: _Color) {
        #if canImport(AppKit)
        self.layer?.backgroundColor = color.cgColor
        #elseif canImport(UIKit)
        self.backgroundColor = color
        #endif
    }
}
