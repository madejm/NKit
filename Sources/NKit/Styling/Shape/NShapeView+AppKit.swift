import Foundation
#if canImport(AppKit)
import AppKit

internal final class NShapeView: NSView {
    
    private var shapeLayer: CAShapeLayer? {
        layer as? CAShapeLayer
    }
    
    private let shape: NShape
    private let color: _Color
    
    internal init(shape: NShape, color: _Color) {
        self.shape = shape
        self.color = color
        
        super.init(frame: .zero)
        
        self.layer = CAShapeLayer()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        
        let path: NSBezierPath = shape.bezierPath(in: bounds)
        
        shapeLayer?.frame = bounds
        shapeLayer?.path = path.quartzPath
        shapeLayer?.fillColor = color.cgColor
    }
}
#endif
