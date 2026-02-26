import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension _View {
    public func border(
        _ color: _Color,
        width: CGFloat = 1
    ) -> Self {
        #if canImport(AppKit)
        self.layer?.borderWidth = width
        self.layer?.borderColor = color.cgColor
        #elseif canImport(UIKit)
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        #endif
        
        return self
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    NViewPreview {
        NVStack {
            NColor(.green)
                .frame(width: 100, height: 100)
            
            NColor(.green)
                .frame(width: 100, height: 100)
                .border(.red, width: 25)
        }
        .padding(20)
    }
}
#endif
