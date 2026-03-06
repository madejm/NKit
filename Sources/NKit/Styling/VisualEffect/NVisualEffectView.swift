import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NVisualEffectView {
    public enum GlassStyle: Equatable, Hashable, Sendable, CaseIterable {
        /// Standard glass effect style.
        case regular
        
        /// Clear glass effect style.
        case clear
        
        internal var fallbackMaterial: Material {
            switch self {
            case .regular: .ultraThinMaterial
            case .clear:   .material
            }
        }
    }
    
    public enum Material: Equatable, Hashable, Sendable, CaseIterable {
        case extraLight
        case light
        case dark
        case regular
//        case prominent
        
        case ultraThinMaterial
        case thinMaterial
        case material
        case thickMaterial
        case chromeMaterial
        
        case ultraThinMaterialLight
        case thinMaterialLight
        case materialLight
        case thickMaterialLight
        case chromeMaterialLight
        
        case ultraThinMaterialDark
        case thinMaterialDark
        case materialDark
        case thickMaterialDark
        case chromeMaterialDark
        
        public enum Basic {
            public static var extraLight: Material { .extraLight }
            public static var light: Material      { .light }
            public static var dark: Material       { .dark }
            public static var regular: Material    { .regular }
//            public static var prominent: Material  { .prominent }
            
            public static var allCases: [Material] {[
                Basic.extraLight,
                Basic.light,
                Basic.dark,
                Basic.regular,
//                Basic.prominent
            ]}
        }
        
        public enum System {
            public static var ultraThin: Material { .ultraThinMaterial }
            public static var thin: Material      { .thinMaterial }
            public static var regular: Material   { .material }
            public static var thick: Material     { .thickMaterial }
            public static var chrome: Material    { .chromeMaterial }
            
            public static var allCases: [Material] {[
                System.ultraThin,
                System.thin,
                System.regular,
                System.thick,
                System.chrome
            ]}
            
            public enum Light {
                public static var ultraThinMaterial: Material { .ultraThinMaterialLight }
                public static var thinMaterial: Material      { .thinMaterialLight }
                public static var material: Material          { .materialLight }
                public static var thickMaterial: Material     { .thickMaterialLight }
                public static var chromeMaterial: Material    { .chromeMaterialLight }
                
                public static var allCases: [Material] {[
                    Light.ultraThinMaterial,
                    Light.thinMaterial,
                    Light.material,
                    Light.thickMaterial,
                    Light.chromeMaterial
                ]}
            }
            
            public enum Dark {
                public static var ultraThinMaterial: Material { .ultraThinMaterialDark }
                public static var thinMaterial: Material      { .thinMaterialDark }
                public static var material: Material          { .materialDark }
                public static var thickMaterial: Material     { .thickMaterialDark }
                public static var chromeMaterial: Material    { .chromeMaterialDark }
                
                public static var allCases: [Material] {[
                    Dark.ultraThinMaterial,
                    Dark.thinMaterial,
                    Dark.material,
                    Dark.thickMaterial,
                    Dark.chromeMaterial
                ]}
            }
        }
    }
    
    public convenience init(
        cornerRadius: CGFloat = 16.0,
        tintColor: _Color? = nil,
        style: GlassStyle = .regular,
        interactive: Bool = false,
        _ view: () -> _View
    ) {
        self.init(
            cornerRadius: cornerRadius,
            tintColor: tintColor,
            style: style,
            interactive: interactive,
            view()
        )
    }
    
    public convenience init(
        cornerRadius: CGFloat = 16.0,
        tintColor: _Color? = nil,
        material: Material,
        _ view: () -> _View
    ) {
        self.init(
            cornerRadius: cornerRadius,
            tintColor: tintColor,
            material: material,
            view()
        )
    }
}

#if DEBUG
internal enum NVisualEffectView_PreviewHelper {
    static let padding: CGFloat = 12
    
    @MainActor
    private static func allMaterials(_ materials: [NVisualEffectView.Material]) -> NView {
        NForEach(materials) { material in
            NHStack {
                NVisualEffectView(
                    material: material
                ) {
                    NText("\(material)")
                        .padding(padding)
                }
                
                NVisualEffectView(
                    tintColor: .blue.opacity(0.5),
                    material: material
                ) {
                    NText("\(material)")
                        .padding(padding)
                }
            }
        }
    }
    
    
    @MainActor
    static var preview: _View {
        NScrollView(axes: .vertical) {
            NVStack {
                NColor.clear.frame(height: 200)
                
                NHStack {
                    NText("transparent")
                        .padding(padding)
                        .background(.white.opacity(0.1))
                    
                    NText("blue")
                        .padding(padding)
                        .background(.blue.opacity(0.5))
                }
                
                NForEach(NVisualEffectView.GlassStyle.allCases) { style in
                    NHStack {
                        NVisualEffectView(
                            style: style,
                            interactive: true
                        ) {
                            NText("\(style)")
                                .padding(padding)
                        }
                        
                        NVisualEffectView(
                            tintColor: .blue.opacity(0.5),
                            style: style,
                            interactive: true
                        ) {
                            NText("\(style)")
                                .padding(padding)
                        }
                    }
                }
                
                allMaterials(NVisualEffectView.Material.Basic.allCases)
                allMaterials(NVisualEffectView.Material.System.allCases)
                allMaterials(NVisualEffectView.Material.System.Light.allCases)
                allMaterials(NVisualEffectView.Material.System.Dark.allCases)
                
                NColor.clear.frame(height: 200)
            }
            .padding(20)
        }
        .background {
            NImage(_Image(named: "lena", in: .module)!, contentMode: .fill)
        }
    }
}
#endif
