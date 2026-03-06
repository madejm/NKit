import Foundation
#if canImport(AppKit)
import AppKit
#if DEBUG
import SwiftUI
#endif

extension NVisualEffectView.GlassStyle {
    @available(macOS 26.0, *)
    fileprivate var style: NSGlassEffectView.Style {
        switch self {
        case .regular: .regular
        case .clear:   .clear
        }
    }
}

extension NVisualEffectView.Material {
    fileprivate var material: NSVisualEffectView.Material {
        switch self {
        case .extraLight:                 .titlebar
        case .light:                      .light
        case .dark:                       .dark
        case .regular:                    .fullScreenUI
//            case .regular:                    .mediumLight
//            case .regular:                    .ultraDark
            
        case .ultraThinMaterial,
                .ultraThinMaterialLight,
                .ultraThinMaterialDark:   .hudWindow // fullScreenUI
        case .thinMaterial,
                .thinMaterialLight,
                .thinMaterialDark:        .popover
        case .material,
                .materialLight,
                .materialDark:            .menu
        case .thickMaterial,
                .thickMaterialLight,
                .thickMaterialDark:       .underWindowBackground
        case .chromeMaterial,
                .chromeMaterialLight,
                .chromeMaterialDark:      .underPageBackground
        }
    }
    
    fileprivate var appearance: NSAppearance.Name? {
        switch self {
        case .extraLight:             .aqua
            
        case .ultraThinMaterialLight: .aqua
        case .thinMaterialLight:      .aqua
        case .materialLight:          .aqua
        case .thickMaterialLight:     .aqua
        case .chromeMaterialLight:    .aqua
        
        case .ultraThinMaterialDark:  .darkAqua
        case .thinMaterialDark:       .darkAqua
        case .materialDark:           .darkAqua
        case .thickMaterialDark:      .darkAqua
        case .chromeMaterialDark:     .darkAqua
            
        default: nil
        }
    }
}
    
public final class NVisualEffectView: BaseView {
    private let effectView: NSView
    private let tintLayer: CALayer?
    
    public convenience init(
        cornerRadius: CGFloat = 16.0,
        tintColor: _Color? = nil,
        style: GlassStyle = .regular,
        interactive: Bool = false,
        _ view: _View
    ) {
        if #available(macOS 26.0, *) {
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
    
    @available(macOS 26.0, *)
    private init(
        cornerRadius: CGFloat,
        tintColor: _Color?,
        glassStyle: GlassStyle,
        interactive: Bool,
        view: _View
    ) {
        let glassEffectView = NSGlassEffectView()
        glassEffectView.cornerRadius = cornerRadius
        glassEffectView.tintColor = tintColor
        glassEffectView.style = glassStyle.style
        glassEffectView.contentView = view
        self.effectView = glassEffectView
        self.tintLayer = nil
        
        super.init()
        
        self.addSubviewAutomatically(effectView)
    }
    
    public init(
        cornerRadius: CGFloat = 16.0,
        tintColor: _Color? = nil,
        material: Material,
        _ view: _View
    ) {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material.material
        visualEffectView.blendingMode = .withinWindow
//        visualEffectView.overrideUserInterfaceStyle
        if let appearance: NSAppearance.Name = material.appearance {
            visualEffectView.appearance = NSAppearance(named: appearance)
        }
        visualEffectView.addSubviewAutomatically(view)
        self.effectView = visualEffectView
        
        let tintLayer = CALayer()
        tintLayer.compositingFilter = "colorBlendMode"
        tintLayer.backgroundColor = tintColor?.cgColor
        self.tintLayer = tintLayer
        
        super.init()
        
        self.layer?.cornerRadius = cornerRadius
        self.layer?.masksToBounds = true
        self.addSubviewAutomatically(effectView)
        
        tintLayer.frame = self.bounds
        self.layer?.insertSublayer(tintLayer, at: 0)
    }
    
    public init(
        cornerRadius: CGFloat = 16.0,
        tintColor: _Color? = nil,
        systemMaterial: NSVisualEffectView.Material,
        _ view: () -> _View
    ) {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = systemMaterial
        visualEffectView.blendingMode = .withinWindow
        visualEffectView.addSubviewAutomatically(view())
        self.effectView = visualEffectView
        self.tintLayer = nil
        
        super.init()
        
        self.layer?.cornerRadius = cornerRadius
        self.layer?.masksToBounds = true
        self.addSubviewAutomatically(effectView)
    }
    
    public override func layout() {
        super.layout()
        
        tintLayer?.frame = self.bounds
    }
}

#if DEBUG
extension NVisualEffectView_PreviewHelper {
    
    private static var systemMaterials: [(NSVisualEffectView.Material, String)] {[
        (.titlebar, "titlebar"),
        (.selection, "selection"),
        (.menu, "menu"),
        (.popover, "popover"),
        (.sidebar, "sidebar"),
        (.headerView, "headerView"),
        (.sheet, "sheet"),
        (.windowBackground, "windowBackground"),
        (.hudWindow, "hudWindow"),
        (.fullScreenUI, "fullScreenUI"),
        (.toolTip, "toolTip"),
        (.contentBackground, "contentBackground"),
        (.underWindowBackground, "underWindowBackground"),
        (.underPageBackground, "underPageBackground"),
        (.appearanceBased, "appearanceBased"),
        (.light, "light"),
        (.dark, "dark"),
        (.mediumLight, "mediumLight"),
        (.ultraDark, "ultraDark")
    ]}
    
    @MainActor
    static var systemMaterialPreview: _View {
        NScrollView(axes: .vertical) {
            NVStack {
                NColor.clear.frame(height: 200)
                
                NForEach(systemMaterials) { systemMaterial in
                    NHStack {
                        NVisualEffectView(
                            systemMaterial: systemMaterial.0,
                        ) {
                            NText(systemMaterial.1)
                                .padding(padding)
                        }
                    }
                }
                
                NColor.clear.frame(height: 200)
            }
            .padding(20)
        }
        .background {
            NImage(_Image(named: "lena", in: .module)!, contentMode: .fill)
        }
    }
    
    @available(macOS 12.0, *)
    static var swiftUIMaterials: [(Material, String)] {[
        (.ultraThinMaterial, "ultraThinMaterial"),
        (.thinMaterial, "thinMaterial"),
        (.regularMaterial, "regularMaterial"),
        (.thickMaterial, "thickMaterial"),
        (.ultraThickMaterial, "ultraThickMaterial")
    ]}
    
    @available(macOS 12.0, *)
    static var swiftUIPreview: some View {
        ScrollView(.vertical) {
            VStack(spacing: 8) {
                Color.clear.frame(width: 10, height: 200)
                
                ForEach(swiftUIMaterials, id: \.1) { material in
                    Text("\(material.1)")
                        .padding(12)
                        .background(material.0, in: RoundedRectangle(cornerRadius: 16))
                }
                
                Color.clear.frame(width: 10, height: 200)
            }
            .padding(20)
        }
        .frame(width: 200)
        .background(Image("lena", bundle: .module).resizable())
    }
}

@available(macOS 14.0, *)
#Preview("System materials") {
    HStack {
//        NVisualEffectView_PreviewHelper.swiftUIPreview
//            .colorScheme(.light)
//            .frame(width: 200)
        
        NViewPreview {
            NVisualEffectView_PreviewHelper.preview
        }
        .colorScheme(.light)
        .frame(width: 300)
        
        NViewPreview {
            NVisualEffectView_PreviewHelper.systemMaterialPreview
        }
        .colorScheme(.light)
        .frame(width: 200)
        
//        NVisualEffectView_PreviewHelper.swiftUIPreview
//            .colorScheme(.dark)
//            .frame(width: 200)
        
        NViewPreview {
            NVisualEffectView_PreviewHelper.preview
        }
        .colorScheme(.dark)
        .frame(width: 300)
        
        NViewPreview {
            NVisualEffectView_PreviewHelper.systemMaterialPreview
        }
        .colorScheme(.dark)
        .frame(width: 200)
    }
    .frame(height: 600)
}
#endif
#endif
