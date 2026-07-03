import Foundation
#if canImport(AppKit)
import AppKit

internal final class NShapeView: NSView {
    
    internal var shapeLayer: CAShapeLayer? {
        layer as? CAShapeLayer
    }
    
    private let shape: NShape
    private let color: _Color
    
    internal init(shape: NShape, color: _Color) {
        self.shape = shape
        self.color = color
        
        super.init(frame: .zero)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 0
        self.layer = shapeLayer
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        
        guard let shapeLayer else {
            return
        }
        
        let pathRect: CGRect = CGRect(
            x: bounds.origin.x + shapeLayer.lineWidth/2,
            y: bounds.origin.y + shapeLayer.lineWidth/2,
            width: bounds.size.width - shapeLayer.lineWidth,
            height: bounds.size.height - shapeLayer.lineWidth
        )
        let path: NSBezierPath = shape.bezierPath(in: pathRect)
        
        shapeLayer.frame = bounds
        shapeLayer.path = path.quartzPath
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
