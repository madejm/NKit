import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

/// A view that arranges its subviews in a vertical line.
public class NVStack: NViewStack {
    public init(
        alignment: Alignment = .center,
        spacing: CGFloat = NKitDefaults.stackSpacing,
        hugging: NStackHugging = NKitDefaults.stackHugging,
        @NViewBuilder _ content: @escaping () -> [NView]
    ) {
        super.init(
            alignment: alignment.alignment,
            orientation: .vertical,
            spacing: spacing,
            hugging: hugging,
            content: content
        )
    }
}

/// A view that arranges its subviews in a horizontal line.
public class NHStack: NViewStack {
    public init(
        alignment: Alignment = .center,
        spacing: CGFloat = NKitDefaults.stackSpacing,
        hugging: NStackHugging = NKitDefaults.stackHugging,
        @NViewBuilder _ content: @escaping () -> [NView]
    ) {
        super.init(
            alignment: alignment.alignment,
            orientation: .horizontal,
            spacing: spacing,
            hugging: hugging,
            content: content
        )
    }
}

#if DEBUG
@available(macOS 12.0, iOS 15.0, *)
#Preview {
    VStack {
        HStack {
            Color.red
            Color.blue
        }
        .background(.yellow)
        NViewPreview {
            NHStack {
                NColor(.red)
                NColor(.blue)
            }
            .background(.yellow)
        }
        .background(.green)
        
        HStack {
            Color.orange
            Color.purple
                .frame(width: 20)
        }
        .background(.yellow)
        NViewPreview {
            NHStack {
                NColor(.orange)
                NColor(.purple)
                    .frame(width: 20)
            }
            .background(.yellow)
        }
        .background(.green)
        
        HStack {
            Color.orange
            Color.orange
            Color.purple
                .frame(width: 20)
        }
        .background(.yellow)
        NViewPreview {
            NHStack {
                NColor(.orange)
                NColor(.orange)
                NColor(.purple)
                    .frame(width: 20)
            }
            .background(.yellow)
        }
        .background(.green)
        
        HStack {
            Color.white
                .frame(height: 20)
            Color.black
                .frame(height: 30)
        }
        .background(.yellow)
        NViewPreview {
            NHStack {
                NColor(.white)
                    .frame(height: 20)
                NColor(.black)
                    .frame(height: 30)
            }
            .background(.yellow)
        }
        .background(.green)
        
        HStack {
            Color.indigo
                .frame(width: 30, height: 20)
            Color.cyan
                .frame(width: 20, height: 30)
        }
        .background(.yellow)
        NViewPreview {
            NHStack {
                NColor(.magenta)
                    .frame(width: 30, height: 20)
                NColor(.cyan)
                    .frame(width: 20, height: 30)
            }
            .background(.yellow)
        }
        .background(.green)
    }
    .background(.gray)
}
#endif
