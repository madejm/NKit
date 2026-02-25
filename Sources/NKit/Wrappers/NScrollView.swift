import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NScrollView {
    
    public struct Axis: OptionSet {
        nonisolated(unsafe) public static let horizontal = Axis(rawValue: 1 << 0)
        nonisolated(unsafe) public static let vertical = Axis(rawValue: 1 << 1)
        nonisolated(unsafe) public static let both: Axis = [.horizontal, .vertical]
        
        public let rawValue: Int8
        
        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }
    }
    
    public convenience init(
        axes: Axis = .both,
        showsIndicators: Bool = true,
        _ content: () -> _View
    ) {
        self.init(
            axes: axes,
            showsIndicators: showsIndicators,
            content()
        )
    }
}

extension NScrollView {
    public enum KnobStyle {
        case `default`
        case dark
        case light
        
        #if canImport(AppKit)
        fileprivate var style: NSScroller.KnobStyle {
            switch self {
            case .`default`: .`default`
            case .dark:      .dark
            case .light:     .light
            }
        }
        #elseif canImport(UIKit)
        fileprivate var style: UIScrollView.IndicatorStyle {
            switch self {
            case .`default`: .`default`
            case .dark:      .black
            case .light:     .white
            }
        }
        #endif
    }
    
    public enum MacOSScrollerStyle {
        case legacy
        case overlay
        
        #if canImport(AppKit)
        fileprivate var style: NSScroller.Style {
            switch self {
            case .legacy:  .legacy
            case .overlay: .overlay
            }
        }
        #endif
    }
    
    public func scrollViewKnobStyle(_ style: KnobStyle) -> Self {
        #if canImport(AppKit)
        self.scrollerKnobStyle = style.style
        #elseif canImport(UIKit)
        self.indicatorStyle = style.style
        #endif
        return self
    }
    
    public func scrollViewScrollerStyle(_ style: MacOSScrollerStyle) -> Self {
        #if canImport(AppKit)
        self.scrollerStyle = style.style
        #endif
        return self
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState var isOn: Bool = false
    
    var title: NGet<String> = $isOn.get.map {
        $0 ? "On" : "Off"
    }
    
    NViewPreview {
        NVStack(spacing: 8) {
            NScrollView(axes: .both) {
                NLinearGradient(
                    colors: [.red, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 1000, height: 1000)
            }
            .scrollViewKnobStyle(.dark)
            .frame(width: 300, height: 200)
            
            NScrollView(axes: .vertical) {
                NLinearGradient(
                    colors: [.green, .purple],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 1000)
            }
            .scrollViewKnobStyle(.light)
            .frame(width: 300, height: 200)
            
            NScrollView(axes: .horizontal) {
                NLinearGradient(
                    colors: [.yellow, .orange],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 1000)
            }
            .scrollViewScrollerStyle(.overlay)
            .frame(width: 300, height: 200)
        }
        .padding(20)
    }
}
#endif
