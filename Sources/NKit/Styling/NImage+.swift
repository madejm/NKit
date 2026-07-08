import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NImage {
    public enum TemplateRenderingMode {
        case original
        case template
    }
    
    public func renderingMode(_ renderingMode: NImage.TemplateRenderingMode?) -> Self {
        imageHooks.append {
            $0 = $0?.renderingMode(renderingMode)
        }
        return self
    }
    
    public func renderingMode(_ renderingMode: NGet<NImage.TemplateRenderingMode?>) -> Self {
        imageHooks.append {
            $0 = $0?.renderingMode(renderingMode.wrappedValue)
        }
        
        renderingMode.onChange { [weak self] _ in
            self?.image = self?.image
        }
        return self
    }
    
    public func foregroundStyle(_ color: _Color) -> Self {
        #if canImport(AppKit)
        self.contentTintColor = color
        #elseif canImport(UIKit)
        self.tintColor = color
        #endif
        return self
    }
    
    public func foregroundStyle(_ color: NGet<_Color>) -> Self {
        #if canImport(AppKit)
        self.contentTintColor = color.wrappedValue
        #elseif canImport(UIKit)
        self.tintColor = color.wrappedValue
        #endif
        
        color.onChange { [weak self] in
            #if canImport(AppKit)
            self?.contentTintColor = $0
            #elseif canImport(UIKit)
            self?.tintColor = $0
            #endif
        }
        return self
    }
}

#if canImport(AppKit)
extension NSImage {
    fileprivate func renderingMode(_ renderingMode: NImage.TemplateRenderingMode?) -> NSImage {
        switch renderingMode {
        case .original:
            self.isTemplate = false
        case .template:
            self.isTemplate = true
        case .none:
            break
        }
        return self
    }
}
#elseif canImport(UIKit)
extension UIImage {
    fileprivate func renderingMode(_ renderingMode: NImage.TemplateRenderingMode?) -> UIImage {
        switch renderingMode {
        case .original:
            return self.withRenderingMode(.alwaysOriginal)
        case .template:
            return self.withRenderingMode(.alwaysTemplate)
        case .none:
            return self.withRenderingMode(.automatic)
        }
    }
}
#endif

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState var template: Bool = true
    @Previewable @NState var color: Bool = false
    
    NViewPreview {
        NVStack {
            NHStack {
                NSwitch($template)
                NSwitch($color)
            }
            
            NImage(_Image(systemName: "desktopcomputer"))
                .renderingMode(.template)
                .foregroundStyle(.red)
                .frame(width: 60, height: 60)
            
            NImage(_Image(systemName: "macpro.gen1.fill"))
                .renderingMode(.original)
                .foregroundStyle(.orange)
                .frame(width: 60, height: 60)
            
            NImage(_Image(systemName: "macpro.gen2.fill"))
                .renderingMode($template.map { $0 ? .template : .original })
                .foregroundStyle($color.map { $0 ? .green : .purple })
                .frame(width: 60, height: 60)
            
            NImage(_Image(systemName: "macpro.gen3.fill")?.renderingMode(.template))
                .apply {
                    #if canImport(AppKit)
                    $0.contentTintColor = .blue
                    #elseif canImport(UIKit)
                    $0.tintColor = .blue
                    #endif
                }
                .frame(width: 60, height: 60)
        }
    }
}
#endif
