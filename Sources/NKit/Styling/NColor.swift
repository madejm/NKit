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
        
        self.backgroundColor = colorBinding.wrappedValue
        
        colorBinding.onChange { [weak self] newColor in
            self?.backgroundColor = newColor
        }
    }
}

extension _Color {
    @inline(__always)
    public func opacity(_ opacity: CGFloat) -> _Color {
        self.withAlphaComponent(opacity)
    }
}

extension _Color: NView {
    
    public var body: _View {
        NColor(self)
    }
    
    @MainActor
    public var color: NColor {
        NColor(self)
    }
}
