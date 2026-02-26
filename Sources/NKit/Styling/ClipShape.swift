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
    public func clipShape(
        _ shape: NShape
    ) -> _View {
        NClipShapeView(
            shape: shape,
            view: self
        )
    }
}

private final class NClipShapeView: BaseView {
    
    private let shape: NShape
    private let subview: _View
    private let shapeLayer = CAShapeLayer()
    
    internal init(
        shape: NShape,
        view: _View
    ) {
        self.shape = shape
        self.subview = view
        
        super.init()
        
        self.addSubviewAutomatically(view)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if canImport(AppKit)
    override func layout() {
        super.layout()
        
        let path: NSBezierPath = shape.bezierPath(in: bounds)
        shapeLayer.frame = bounds
        shapeLayer.path = path.quartzPath
        
        subview.layer?.mask = shapeLayer
    }
    #elseif canImport(UIKit)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path: UIBezierPath = shape.bezierPath(in: bounds)
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        
        subview.layer.mask = shapeLayer
    }
    #endif
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    NViewPreview {
        NHStack {
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
            
            NHStack {
                NForEach(0...1) { _ in
                    NVStack {
                        NForEach(colorShapes) { colorShape in
                            NColor(colorShape.0)
                                .clipShape(colorShape.1)
                                .frame(width: 150, height: 100)
                        }
                    }
                }
            }
        }
        .padding(20)
    }
}
#endif
