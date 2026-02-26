import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _BezierPath {
    private static let ellipseCoefficient: CGFloat = 1.28195
    
    internal convenience init(
        continuousRoundedRect rect: CGRect,
        topLeft: CGFloat,
        topRight: CGFloat,
        bottomRight: CGFloat,
        bottomLeft: CGFloat
    ) {
        self.init()
        
        let cornerRadiusTuple: (topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) = (topLeft, topRight, bottomLeft, bottomRight)
        let cornerRadius = cornerRadiusTuple//Self.minimumCornerRadius(for: rect, cornerRadius: cornerRadiusTuple)
        
        let coefficients: [CGFloat] = [0.04641, 0.08715, 0.13357, 0.16296, 0.21505, 0.290086, 0.32461, 0.37801, 0.44576, 0.6074, 0.77037]
        
        let topRightP1 = CGPoint(x: rect.width - cornerRadius.topRight * Self.ellipseCoefficient, y: rect.origin.y)
        let topRightP1CP1 = CGPoint(x: topRightP1.x + cornerRadius.topRight * coefficients[8], y: topRightP1.y)
        let topRightP1CP2 = CGPoint(x: topRightP1.x + cornerRadius.topRight * coefficients[9], y: topRightP1.y + cornerRadius.topRight * coefficients[0])
        
        let topRightP2 = CGPoint(x: topRightP1.x + cornerRadius.topRight * coefficients[10], y: topRightP1.y + cornerRadius.topRight * coefficients[2])
        let topRightP2CP1 = CGPoint(x: topRightP2.x + cornerRadius.topRight * coefficients[3], y: topRightP2.y + cornerRadius.topRight * coefficients[1])
        let topRightP2CP2 = CGPoint(x: topRightP2.x + cornerRadius.topRight * coefficients[5], y: topRightP2.y + cornerRadius.topRight * coefficients[4])
        
        let topRightP3 = CGPoint(x: topRightP2.x + cornerRadius.topRight * coefficients[7], y: topRightP2.y + cornerRadius.topRight * coefficients[7])
        let topRightP3CP1 = CGPoint(x: topRightP3.x + cornerRadius.topRight * coefficients[1], y: topRightP3.y + cornerRadius.topRight * coefficients[3])
        let topRightP3CP2 = CGPoint(x: topRightP3.x + cornerRadius.topRight * coefficients[2], y: topRightP3.y + cornerRadius.topRight * coefficients[6])
        
        let topRightP4 = CGPoint(x: topRightP3.x + cornerRadius.topRight * coefficients[2], y: topRightP3.y + cornerRadius.topRight * coefficients[10])
        
        let bottomRightP1 = CGPoint(x: rect.width, y: rect.height - cornerRadius.bottomRight * Self.ellipseCoefficient)
        let bottomRightP1CP1 = CGPoint(x: bottomRightP1.x, y: bottomRightP1.y + cornerRadius.bottomRight * coefficients[8])
        let bottomRightP1CP2 = CGPoint(x: bottomRightP1.x - cornerRadius.bottomRight * coefficients[0], y: bottomRightP1.y + cornerRadius.bottomRight * coefficients[9])
        
        let bottomRightP2 = CGPoint(x: bottomRightP1.x - cornerRadius.bottomRight * coefficients[2], y: bottomRightP1.y + cornerRadius.bottomRight * coefficients[10])
        let bottomRightP2CP1 = CGPoint(x: bottomRightP2.x - cornerRadius.bottomRight * coefficients[1], y: bottomRightP2.y + cornerRadius.bottomRight * coefficients[3])
        let bottomRightP2CP2 = CGPoint(x: bottomRightP2.x - cornerRadius.bottomRight * coefficients[4], y: bottomRightP2.y + cornerRadius.bottomRight * coefficients[5])
        
        let bottomRightP3 = CGPoint(x: bottomRightP2.x - cornerRadius.bottomRight * coefficients[7], y: bottomRightP2.y + cornerRadius.bottomRight * coefficients[7])
        let bottomRightP3CP1 = CGPoint(x: bottomRightP3.x - cornerRadius.bottomRight * coefficients[3], y: bottomRightP3.y + cornerRadius.bottomRight * coefficients[1])
        let bottomRightP3CP2 = CGPoint(x: bottomRightP3.x - cornerRadius.bottomRight * coefficients[6], y: bottomRightP3.y + cornerRadius.bottomRight * coefficients[2])
        
        let bottomRightP4 = CGPoint(x: bottomRightP3.x - cornerRadius.bottomRight * coefficients[10], y: bottomRightP3.y + cornerRadius.bottomRight * coefficients[2])
        
        let bottomLeftP1 = CGPoint(x: rect.origin.x + cornerRadius.bottomLeft * Self.ellipseCoefficient, y: rect.height)
        let bottomLeftP1CP1 = CGPoint(x: bottomLeftP1.x - cornerRadius.bottomLeft * coefficients[8], y: bottomLeftP1.y)
        let bottomLeftP1CP2 = CGPoint(x: bottomLeftP1.x - cornerRadius.bottomLeft * coefficients[9], y: bottomLeftP1.y - cornerRadius.bottomLeft * coefficients[0])
        
        let bottomLeftP2 = CGPoint(x: bottomLeftP1.x - cornerRadius.bottomLeft * coefficients[10], y: bottomLeftP1.y - cornerRadius.bottomLeft * coefficients[2])
        let bottomLeftP2CP1 = CGPoint(x: bottomLeftP2.x - cornerRadius.bottomLeft * coefficients[3], y: bottomLeftP2.y - cornerRadius.bottomLeft * coefficients[1])
        let bottomLeftP2CP2 = CGPoint(x: bottomLeftP2.x - cornerRadius.bottomLeft * coefficients[5], y: bottomLeftP2.y - cornerRadius.bottomLeft * coefficients[4])
        
        let bottomLeftP3 = CGPoint(x: bottomLeftP2.x - cornerRadius.bottomLeft * coefficients[7], y: bottomLeftP2.y - cornerRadius.bottomLeft * coefficients[7])
        let bottomLeftP3CP1 = CGPoint(x: bottomLeftP3.x - cornerRadius.bottomLeft * coefficients[1], y: bottomLeftP3.y - cornerRadius.bottomLeft * coefficients[3])
        let bottomLeftP3CP2 = CGPoint(x: bottomLeftP3.x - cornerRadius.bottomLeft * coefficients[2], y: bottomLeftP3.y - cornerRadius.bottomLeft * coefficients[6])
        
        let bottomLeftP4 = CGPoint(x: bottomLeftP3.x - cornerRadius.bottomLeft * coefficients[2], y: bottomLeftP3.y - cornerRadius.bottomLeft * coefficients[10])
        
        let topLeftP1 = CGPoint(x: rect.origin.x, y: rect.origin.y + cornerRadius.topLeft * Self.ellipseCoefficient)
        let topLeftP1CP1 = CGPoint(x: topLeftP1.x, y: topLeftP1.y - cornerRadius.topLeft * coefficients[8])
        let topLeftP1CP2 = CGPoint(x: topLeftP1.x + cornerRadius.topLeft * coefficients[0], y: topLeftP1.y - cornerRadius.topLeft * coefficients[9])
        
        let topLeftP2 = CGPoint(x: topLeftP1.x + cornerRadius.topLeft * coefficients[2], y: topLeftP1.y - cornerRadius.topLeft * coefficients[10])
        let topLeftP2CP1 = CGPoint(x: topLeftP2.x + cornerRadius.topLeft * coefficients[1], y: topLeftP2.y - cornerRadius.topLeft * coefficients[3])
        let topLeftP2CP2 = CGPoint(x: topLeftP2.x + cornerRadius.topLeft * coefficients[4], y: topLeftP2.y - cornerRadius.topLeft * coefficients[5])
        
        let topLeftP3 = CGPoint(x: topLeftP2.x + cornerRadius.topLeft * coefficients[7], y: topLeftP2.y - cornerRadius.topLeft * coefficients[7])
        let topLeftP3CP1 = CGPoint(x: topLeftP3.x + cornerRadius.topLeft * coefficients[3], y: topLeftP3.y - cornerRadius.topLeft * coefficients[1])
        let topLeftP3CP2 = CGPoint(x: topLeftP3.x + cornerRadius.topLeft * coefficients[6], y: topLeftP3.y - cornerRadius.topLeft * coefficients[2])
        
        let topLeftP4 = CGPoint(x: topLeftP3.x + cornerRadius.topLeft * coefficients[10], y: topLeftP3.y - cornerRadius.topLeft * coefficients[2])
        
        self.move(to: CGPoint(x: rect.origin.x + cornerRadius.topLeft * Self.ellipseCoefficient, y: rect.origin.y))
        
        // Top right
        self.addLine(to: topRightP1)
        self.addCurve(to: topRightP2, controlPoint1: topRightP1CP1, controlPoint2: topRightP1CP2)
        self.addCurve(to: topRightP3, controlPoint1: topRightP2CP1, controlPoint2: topRightP2CP2)
        self.addCurve(to: topRightP4, controlPoint1: topRightP3CP1, controlPoint2: topRightP3CP2)
        
        // Bottom right
        self.addLine(to: bottomRightP1)
        self.addCurve(to: bottomRightP2, controlPoint1: bottomRightP1CP1, controlPoint2: bottomRightP1CP2)
        self.addCurve(to: bottomRightP3, controlPoint1: bottomRightP2CP1, controlPoint2: bottomRightP2CP2)
        self.addCurve(to: bottomRightP4, controlPoint1: bottomRightP3CP1, controlPoint2: bottomRightP3CP2)
        
        // Bottom left
        self.addLine(to: bottomLeftP1)
        self.addCurve(to: bottomLeftP2, controlPoint1: bottomLeftP1CP1, controlPoint2: bottomLeftP1CP2)
        self.addCurve(to: bottomLeftP3, controlPoint1: bottomLeftP2CP1, controlPoint2: bottomLeftP2CP2)
        self.addCurve(to: bottomLeftP4, controlPoint1: bottomLeftP3CP1, controlPoint2: bottomLeftP3CP2)
        
        // Top Left
        self.addLine(to: topLeftP1)
        self.addCurve(to: topLeftP2, controlPoint1: topLeftP1CP1, controlPoint2: topLeftP1CP2)
        self.addCurve(to: topLeftP3, controlPoint1: topLeftP2CP1, controlPoint2: topLeftP2CP2)
        self.addCurve(to: topLeftP4, controlPoint1: topLeftP3CP1, controlPoint2: topLeftP3CP2)
        
        self.close()
    }
    
    private static func minimumCornerRadius(for rect: CGRect, cornerRadius: (topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat)) -> (topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let calculateMinimumRadius: (CGFloat, CGFloat, CGFloat) -> CGFloat = { (width, height, radius) in
            let minSide = min(width, height)
            let minRadius = min(radius * ellipseCoefficient, minSide)
            
            return minRadius / ellipseCoefficient
        }
        
        let w = rect.width
        let h = rect.height
        
        let minimumTopRight = calculateMinimumRadius(w, h, cornerRadius.topRight)
        let minimumBottomRight = calculateMinimumRadius(w, h - (minimumTopRight * ellipseCoefficient), cornerRadius.bottomRight)
        let minimumBottomLeft = calculateMinimumRadius(w - (minimumBottomRight * ellipseCoefficient), h, cornerRadius.bottomLeft)
        let minimumTopLeft = calculateMinimumRadius(w - (minimumTopRight * ellipseCoefficient), h - (minimumBottomLeft * ellipseCoefficient), cornerRadius.topLeft)
        
        return (minimumTopLeft, minimumTopRight, minimumBottomLeft, minimumBottomRight)
    }
}

extension _BezierPath {
    internal convenience init(
        roundedRect rect: CGRect,
        topLeft: CGFloat,
        topRight: CGFloat,
        bottomRight: CGFloat,
        bottomLeft: CGFloat
    ) {
        self.init()

        // Clamp radii so they don't exceed bounds
        let tl = min(min(topLeft, rect.width / 2), rect.height / 2)
        let tr = min(min(topRight, rect.width / 2), rect.height / 2)
        let br = min(min(bottomRight, rect.width / 2), rect.height / 2)
        let bl = min(min(bottomLeft, rect.width / 2), rect.height / 2)

        let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
        let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)

        // Start at top-left corner
        move(to: CGPoint(x: topLeftPoint.x + tl, y: topLeftPoint.y))

        // Top edge
        addLine(to: CGPoint(x: topRightPoint.x - tr, y: topRightPoint.y))
        addArc(
            withCenter: CGPoint(x: topRightPoint.x - tr, y: topRightPoint.y + tr),
            radius: tr,
            startAngle: -.pi / 2,
            endAngle: 0,
            clockwise: true
        )

        // Right edge
        addLine(to: CGPoint(x: bottomRightPoint.x, y: bottomRightPoint.y - br))
        addArc(
            withCenter: CGPoint(x: bottomRightPoint.x - br, y: bottomRightPoint.y - br),
            radius: br,
            startAngle: 0,
            endAngle: .pi / 2,
            clockwise: true
        )

        // Bottom edge
        addLine(to: CGPoint(x: bottomLeftPoint.x + bl, y: bottomLeftPoint.y))
        addArc(
            withCenter: CGPoint(x: bottomLeftPoint.x + bl, y: bottomLeftPoint.y - bl),
            radius: bl,
            startAngle: .pi / 2,
            endAngle: .pi,
            clockwise: true
        )
        
        // Left edge
        addLine(to: CGPoint(x: topLeftPoint.x, y: topLeftPoint.y + tl))
        addArc(
            withCenter: CGPoint(x: topLeftPoint.x + tl, y: topLeftPoint.y + tl),
            radius: tl,
            startAngle: .pi,
            endAngle: -.pi / 2,
            clockwise: true
        )

        close()
    }
}

#if canImport(AppKit)
extension NSBezierPath {
    internal convenience init(roundedRect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
    
    fileprivate func addCurve(
        to endPoint: CGPoint,
        controlPoint1: CGPoint,
        controlPoint2: CGPoint
    ) {
        curve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    fileprivate func addLine(to point: CGPoint) {
        line(to: point)
    }
    
    fileprivate func addArc(
        withCenter center: NSPoint,
        radius: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        clockwise: Bool
    ) {
        appendArc(
            withCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
    }
    
    internal var quartzPath: CGPath {
        if #available(macOS 14.0, *) {
            return cgPath
        } else {
            let path = CGMutablePath()
            let points = NSPointArray.allocate(capacity: 3)
            
            for i in 0 ..< self.elementCount {
                let type = self.element(at: i, associatedPoints: points)
                switch type {
                case .moveTo:
                    path.move(to: points[0])
                case .lineTo:
                    path.addLine(to: points[0])
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePath:
                    path.closeSubpath()
                case .cubicCurveTo:
                    path.addQuadCurve(to: points[2], control: points[0])
                case .quadraticCurveTo:
                    path.addQuadCurve(to: points[2], control: points[0])
                @unknown default:
                    break
                }
            }
            return path
        }
    }
}
#endif
