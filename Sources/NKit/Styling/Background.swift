import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    #if canImport(AppKit)
    private final class BackgroundView: BaseView {
        fileprivate init(color: NGet<_Color>, subview: _View) {
            super.init()
            
            self.layer?.backgroundColor = color.wrappedValue.cgColor
            
            color.onChange { [weak self] in
                self?.layer?.backgroundColor = $0.cgColor
            }
            
            self.addSubviewAutomatically(subview)
        }
    }
    #endif
    
    public func background(_ color: _Color) -> _View {
        self.background(.constant(color))
    }
    
    public func background(_ color: NGet<_Color>) -> _View {
        #if canImport(AppKit)
        guard let layer = self.layer else {
            return BackgroundView(color: color, subview: self)
        }
        layer.backgroundColor = color.wrappedValue.cgColor
        #elseif canImport(UIKit)
        backgroundColor = color.wrappedValue
        #endif
        
        color.onChange { [weak self] in
            #if canImport(AppKit)
            self?.layer?.backgroundColor = $0.cgColor
            #elseif canImport(UIKit)
            self?.backgroundColor = $0
            #endif
        }
        
        return self
    }
}
