import Foundation
#if canImport(UIKit)
import UIKit

internal final class NShapeView: UIView {
    
    internal override class var layerClass: AnyClass {
       CAShapeLayer.classForCoder()
    }
    
    internal var shapeLayer: CAShapeLayer? {
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
        
        guard let shapeLayer else {
            return
        }
        
        let pathRect: CGRect = CGRect(
            x: bounds.origin.x + shapeLayer.lineWidth/2,
            y: bounds.origin.y + shapeLayer.lineWidth/2,
            width: bounds.size.width - shapeLayer.lineWidth,
            height: bounds.size.height - shapeLayer.lineWidth
        )
        let path: UIBezierPath = shape.bezierPath(in: pathRect)
        
        shapeLayer.frame = frame
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
    }
}

extension NShapeView: NCustomBorder {
    var borderWidth: CGFloat {
        get {
            shapeLayer?.lineWidth ?? 0
        }
        set {
            shapeLayer?.lineWidth = newValue
        }
    }
    
    var borderColor: CGColor? {
        get {
            shapeLayer?.strokeColor
        }
        set {
            shapeLayer?.strokeColor = newValue
        }
    }
}
#endif
