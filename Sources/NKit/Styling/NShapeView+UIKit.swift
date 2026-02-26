import Foundation
#if canImport(UIKit)
import UIKit

internal final class NShapeView: UIView {
    
    internal override class var layerClass: AnyClass {
       CAShapeLayer.classForCoder()
    }
    
    private var shapeLayer: CAShapeLayer? {
        layer as? CAShapeLayer
    }
    
    private let shape: NShape
    private let color: _Color
    
    internal init(shape: NShape, color: _Color) {
        self.shape = shape
        self.color = color
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path: UIBezierPath = shape.bezierPath(in: bounds)
        
        shapeLayer?.frame = frame
        shapeLayer?.path = path.cgPath
        shapeLayer?.fillColor = color.cgColor
    }
}
#endif
