import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

#if canImport(AppKit)
public typealias _BezierPath = NSBezierPath
#elseif canImport(UIKit)
public typealias _BezierPath = UIBezierPath
#endif

public protocol NShape: NView {
    
    func bezierPath(in rect: CGRect) -> _BezierPath
}

extension NShape {
    public func fill(_ color: _Color) -> _View {
        NShapeView(shape: self, color: color)
    }
    
    public var body: _View {
        NShapeView(shape: self, color: .white)
    }
}

public struct NRectangle: NShape {
    public func bezierPath(in rect: CGRect) -> _BezierPath {
        _BezierPath(rect: rect)
    }
}

public struct NRoundedRectangle: NShape {
    public let cornerRadius: CGFloat
    public let style: NRoundedCornerStyle
    
    public init(
        cornerRadius: CGFloat,
        style: NRoundedCornerStyle = .continuous
    ) {
        self.cornerRadius = cornerRadius
        self.style = style
    }
    
    public func bezierPath(in rect: CGRect) -> _BezierPath {
        switch style {
        case .circular:
            return _BezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        case .continuous:
            return _BezierPath(
                continuousRoundedRect: rect,
                topLeft: cornerRadius,
                topRight: cornerRadius,
                bottomRight: cornerRadius,
                bottomLeft: cornerRadius
            )
        }
    }
}

public struct NUnevenRoundedRectangle: NShape {
    public let cornerRadii: NRectangleCornerRadii
    public let style: NRoundedCornerStyle
    
    public init(
        cornerRadii: NRectangleCornerRadii,
        style: NRoundedCornerStyle = .continuous
    ) {
        self.cornerRadii = cornerRadii
        self.style = style
    }
    
    public init(
        topLeadingRadius: CGFloat = 0,
        bottomLeadingRadius: CGFloat = 0,
        bottomTrailingRadius: CGFloat = 0,
        topTrailingRadius: CGFloat = 0,
        style: NRoundedCornerStyle = .continuous
    ) {
        self.cornerRadii = .init(
            topLeading: topLeadingRadius,
            bottomLeading: bottomLeadingRadius,
            bottomTrailing: bottomTrailingRadius,
            topTrailing: topTrailingRadius
        )
        self.style = style
    }
    
    public func bezierPath(in rect: CGRect) -> _BezierPath {
        switch style {
        case .circular:
            return _BezierPath(
                roundedRect: rect,
                topLeft: cornerRadii.topLeading,
                topRight: cornerRadii.topTrailing,
                bottomRight: cornerRadii.bottomTrailing,
                bottomLeft: cornerRadii.bottomLeading
            )
        case .continuous:
            return _BezierPath(
                continuousRoundedRect: rect,
                topLeft: cornerRadii.topLeading,
                topRight: cornerRadii.topTrailing,
                bottomRight: cornerRadii.bottomTrailing,
                bottomLeft: cornerRadii.bottomLeading
            )
        }
    }
}

public struct NCapsule: NShape {
    public let style: NRoundedCornerStyle
    
    public init(
        style: NRoundedCornerStyle = .continuous
    ) {
        self.style = style
    }
    
    public func bezierPath(in rect: CGRect) -> _BezierPath {
        let minSize: CGFloat = min(rect.size.width, rect.size.height)
        
        switch style {
        case .circular:
            return _BezierPath(roundedRect: rect, cornerRadius: minSize/2)
        case .continuous:
            return _BezierPath(roundedRect: rect, cornerRadius: minSize/2)
        }
    }
}

public struct NEllipse: NShape {
    public func bezierPath(in rect: CGRect) -> _BezierPath {
        _BezierPath(ovalIn: rect)
    }
}

public struct NCircle: NShape {
    public func bezierPath(in rect: CGRect) -> _BezierPath {
        let minSize: CGFloat = min(rect.size.width, rect.size.height)
        
        let circleRect: CGRect = CGRect(
            x: rect.origin.x + (rect.size.width - minSize)/2,
            y: rect.origin.y + (rect.size.height - minSize)/2,
            width: minSize,
            height: minSize
        )
        return _BezierPath(ovalIn: circleRect)
    }
}

@frozen
public enum NRoundedCornerStyle: Equatable, Hashable, Sendable, CaseIterable {
    case circular
    case continuous
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)

#Preview {
    NViewPreview {
        NHStack {
            NVStack {
                NRectangle()
                    .fill(.yellow)
                    .frame(width: 150, height: 100)
                
                NHStack {
                    NForEach(NRoundedCornerStyle.allCases) { style in
                        NVStack {
                            NCapsule(style: style)
                                .fill(.green)
                                .frame(width: 150, height: 100)
                            
                            NRoundedRectangle(
                                cornerRadius: 30,
                                style: style
                            )
                            .fill(.blue)
                            .frame(width: 150, height: 100)
                            
                            NUnevenRoundedRectangle(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 30,
                                bottomTrailingRadius: 40,
                                topTrailingRadius: 50,
                                style: style
                            )
                            .fill(.purple)
                            .frame(width: 150, height: 100)
                        }
                    }
                }
                
                NEllipse()
                    .fill(.red)
                    .frame(width: 150, height: 100)
                
                NCircle()
                    .fill(.orange)
                    .frame(width: 150, height: 100)
            }
        }
        .padding(20)
    }
}
#endif
