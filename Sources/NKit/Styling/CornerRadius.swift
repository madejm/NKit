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
    public func cornerRadius(
        _ radius: CGFloat,
        style: CALayerCornerCurve = .continuous
    ) -> Self {
        #if canImport(AppKit)
        self.layer?.cornerRadius = radius
        self.layer?.cornerCurve = style
        #elseif canImport(UIKit)
        self.layer.cornerRadius = radius
        self.layer.cornerCurve = style
        #endif
        
        return self
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    NViewPreview {
        NHStack {
            NVStack {
                NHStack {
                    NColor(.green)
                        .frame(width: 100, height: 100)
                        .cornerRadius(25, style: .circular)
                    
                    NColor(.green)
                        .frame(width: 100, height: 100)
                        .cornerRadius(25, style: .continuous)
                }
                
                NHStack {
                    NColor(.blue)
                        .frame(width: 100, height: 100)
                        .cornerRadius(50, style: .circular)
                    
                    NColor(.blue)
                        .frame(width: 100, height: 100)
                        .cornerRadius(50, style: .continuous)
                }
                
                NHStack {
                    NColor(.red)
                        .frame(width: 100, height: 60)
                        .cornerRadius(30, style: .circular)
                    
                    NColor(.red)
                        .frame(width: 100, height: 60)
                        .cornerRadius(30, style: .continuous)
                }
            }
        }
        .padding(20)
    }
}
#endif
