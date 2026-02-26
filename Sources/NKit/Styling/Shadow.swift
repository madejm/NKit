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
    public func shadow(
        color: _Color = .black.opacity(0.33),
        radius: CGFloat,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) -> Self {
        #if canImport(AppKit)
        let shadow = NSShadow()
        shadow.shadowColor = color
        shadow.shadowBlurRadius = radius
        shadow.shadowOffset = CGSize(width: x, height: -y)
        self.shadow = shadow
        #elseif canImport(UIKit)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: x, height: y)
        #endif
        
        return self
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    NViewPreview {
        NVStack {
            let colorShapes: [(_Color, any NShape)] = [
                (.yellow, NRectangle()),
                (.green, NCapsule()),
                (.blue, NRoundedRectangle(cornerRadius: 30)),
                (.purple, NUnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 30,
                        bottomTrailingRadius: 40,
                        topTrailingRadius: 50
                    )
                ),
                (.red, NEllipse()),
                (.orange, NCircle())
            ]
            
            NColor(.cyan)
                .frame(width: 150, height: 100)
                .cornerRadius(20)
                .shadow(
                    color: .black,
                    radius: 10,
                    x: 10,
                    y: 20
                )
            
            NHStack {
                NVStack {
                    NForEach(colorShapes) { colorShape in
                        colorShape.1
                            .fill(colorShape.0)
                            .frame(width: 150, height: 100)
                            .shadow(
                                color: .black,
                                radius: 10,
                                x: 10,
                                y: 20
                            )
                    }
                }
                NVStack {
                    NForEach(colorShapes) { colorShape in
                        NColor(colorShape.0)
                            .clipShape(colorShape.1)
                            .frame(width: 150, height: 100)
                            .shadow(
                                color: .black,
                                radius: 10,
                                x: 10,
                                y: 20
                            )
                    }
                }
            }
        }
        .padding(20)
        .background(.white)
    }
}
#endif
