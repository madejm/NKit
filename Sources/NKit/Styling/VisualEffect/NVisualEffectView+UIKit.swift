import Foundation
#if canImport(UIKit)
import UIKit
#if DEBUG
import SwiftUI
#endif

extension NVisualEffectView.GlassStyle {
    @available(iOS 26.0, *)
    fileprivate var style: UIGlassEffect.Style {
        switch self {
        case .regular: .regular
        case .clear:   .clear
        }
    }
}

extension NVisualEffectView.Material {
    fileprivate var style: UIBlurEffect.Style {
        switch self {
        case .extraLight:             .extraLight
        case .light:                  .light
        case .dark:                   .dark
        case .regular:                .regular
//            case .prominent:              .prominent
        
        case .ultraThinMaterial:      .systemUltraThinMaterial
        case .thinMaterial:           .systemThinMaterial
        case .material:               .systemMaterial
        case .thickMaterial:          .systemThickMaterial
        case .chromeMaterial:         .systemChromeMaterial
        
        case .ultraThinMaterialLight: .systemUltraThinMaterialLight
        case .thinMaterialLight:      .systemThinMaterialLight
        case .materialLight:          .systemMaterialLight
        case .thickMaterialLight:     .systemThickMaterialLight
        case .chromeMaterialLight:    .systemChromeMaterialLight
        
        case .ultraThinMaterialDark:  .systemUltraThinMaterialDark
        case .thinMaterialDark:       .systemThinMaterialDark
        case .materialDark:           .systemMaterialDark
        case .thickMaterialDark:      .systemThickMaterialDark
        case .chromeMaterialDark:     .systemChromeMaterialDark
        }
    }
}

public final class NVisualEffectView: BaseView {
    private let effectView: UIView
    
    public convenience init(
        cornerRadius: CGFloat = 16.0,
        tintColor: _Color? = nil,
        style: GlassStyle = .regular,
        interactive: Bool = false,
        _ view: _View
    ) {
        if #available(iOS 26.0, *) {
            self.init(
                cornerRadius: cornerRadius,
                tintColor: tintColor,
                glassStyle: style,
                interactive: interactive,
                view: view
            )
        } else {
            self.init(
                cornerRadius: cornerRadius,
                tintColor: tintColor,
                material: style.fallbackMaterial,
                view
            )
        }
    }
    
    @available(iOS 26.0, *)
    private init(
        cornerRadius: CGFloat,
        tintColor: _Color?,
        glassStyle: GlassStyle,
        interactive: Bool,
        view: _View
    ) {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.contentView.addSubviewAutomatically(view)
        
        self.effectView = visualEffectView
        
        let effect = UIGlassEffect(style: glassStyle.style)
        effect.isInteractive = interactive
        effect.tintColor = tintColor
        visualEffectView.effect = effect
        visualEffectView.layer.cornerRadius = cornerRadius
        
        super.init()
        
        self.addSubviewAutomatically(effectView)
    }
    
    public init(
        cornerRadius: CGFloat = 16.0,
        tintColor: _Color? = nil,
        material: Material,
        _ view: _View
    ) {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.contentView.addSubviewAutomatically(view)
        
        self.effectView = visualEffectView
        
        let effect = UIBlurEffect(style: material.style)
        visualEffectView.effect = effect
        visualEffectView.contentView.backgroundColor = tintColor
        visualEffectView.layer.cornerRadius = cornerRadius
        visualEffectView.clipsToBounds = true
        
        super.init()
        
        self.addSubviewAutomatically(effectView)
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview("Light") {
    NViewPreview {
        NVisualEffectView_PreviewHelper.preview
    }
    .preferredColorScheme(.light)
}

@available(iOS 17.0, *)
#Preview("Dark") {
    NViewPreview {
        NVisualEffectView_PreviewHelper.preview
    }
    .preferredColorScheme(.dark)
}
#endif
#endif
