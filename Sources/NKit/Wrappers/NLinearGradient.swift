import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NLinearGradient {
    public struct UnitPoint: Sendable, Equatable {
        public var x: CGFloat
        public var y: CGFloat
        
        public init(x: CGFloat = 0, y: CGFloat = 0) {
            self.x = x
            self.y = y
        }
        
        public static let zero: UnitPoint           = .init(x: 0.0, y: 0.0)
        public static let topLeading: UnitPoint     = .init(x: 0.0, y: 0.0)
        public static let top: UnitPoint            = .init(x: 0.5, y: 0.0)
        public static let topTrailing: UnitPoint    = .init(x: 1.0, y: 0.0)
        public static let leading: UnitPoint        = .init(x: 0.0, y: 0.5)
        public static let center: UnitPoint         = .init(x: 0.5, y: 0.5)
        public static let trailing: UnitPoint       = .init(x: 1.0, y: 0.5)
        public static let bottomLeading: UnitPoint  = .init(x: 0.0, y: 1.0)
        public static let bottom: UnitPoint         = .init(x: 0.5, y: 1.0)
        public static let bottomTrailing: UnitPoint = .init(x: 1.0, y: 1.0)
        
        internal var point: CGPoint {
            #if canImport(AppKit)
            .init(x: x, y: 1 - y)
            #elseif canImport(UIKit)
            .init(x: x, y: y)
            #endif
        }
    }
    
    public struct Stop: Sendable, Equatable {
        public var color: _Color
        public var location: CGFloat
        
        public init(color: _Color, location: CGFloat) {
            self.color = color
            self.location = location
        }
    }
}

extension NLinearGradient {
    public convenience init(
        colors: NGet<[_Color]>,
        startPoint: NGet<NLinearGradient.UnitPoint>,
        endPoint: NGet<NLinearGradient.UnitPoint>
    ) {
        self.init(
            colors: colors,
            locations: nil,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    public convenience init(
        colors: [_Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.init(
            colors: .constant(colors),
            locations: nil,
            startPoint: .constant(startPoint),
            endPoint: .constant(endPoint)
        )
    }
    
    public convenience init(
        colors: NGet<[_Color]>,
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.init(
            colors: colors,
            locations: nil,
            startPoint: .constant(startPoint),
            endPoint: .constant(endPoint)
        )
    }
    
    public convenience init(
        colors: [_Color],
        startPoint: NGet<NLinearGradient.UnitPoint>,
        endPoint: NGet<NLinearGradient.UnitPoint>
    ) {
        self.init(
            colors: .constant(colors),
            locations: nil,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

extension NLinearGradient {
    public convenience init(
        stops: NGet<[Stop]>,
        startPoint: NGet<UnitPoint>,
        endPoint: NGet<UnitPoint>
    ) {
        self.init(
            colors: stops.map {
                $0.map(\.color)
            },
            locations: stops.map {
                $0.map(\.location)
            },
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    public convenience init(
        stops: [Stop],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.init(
            colors: .constant(stops.map(\.color)),
            locations: .constant(stops.map(\.location)),
            startPoint: .constant(startPoint),
            endPoint: .constant(endPoint)
        )
    }
    
    public convenience init(
        stops: NGet<[Stop]>,
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.init(
            colors: stops.map {
                $0.map(\.color)
            },
            locations: stops.map {
                $0.map(\.location)
            },
            startPoint: .constant(startPoint),
            endPoint: .constant(endPoint)
        )
    }
    
    public convenience init(
        stops: [Stop],
        startPoint: NGet<UnitPoint>,
        endPoint: NGet<UnitPoint>
    ) {
        self.init(
            colors: .constant(stops.map(\.color)),
            locations: .constant(stops.map(\.location)),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    let size: CGFloat = 80
    
    NViewPreview {
        NHStack {
            NVStack(spacing: 8) {
                NHStack(spacing: 8) {
                    NLinearGradient(
                        colors: [.red, .yellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        colors: [.green, .purple],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        colors: [.cyan, .magenta],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        colors: [.blue, .orange],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                    .frame(width: size, height: size)
                }
                NHStack(spacing: 8) {
                    NLinearGradient(
                        colors: [.red, .yellow],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        colors: [.green, .purple],
                        startPoint: .center,
                        endPoint: .trailing
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        colors: [.cyan, .magenta],
                        startPoint: .leading,
                        endPoint: .topTrailing
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        colors: [.blue, .clear],
                        startPoint: .trailing,
                        endPoint: .bottom
                    )
                    .frame(width: size, height: size)
                    .background(.black)
                }
                NHStack(spacing: 8) {
                    NLinearGradient(
                        stops: [
                            .init(color: .red, location: 0.0),
                            .init(color: .blue, location: 0.5),
                            .init(color: .yellow, location: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        stops: [
                            .init(color: .green, location: 0.5),
                            .init(color: .white, location: 0.75),
                            .init(color: .purple, location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        stops: [
                            .init(color: .cyan, location: -0.5),
                            .init(color: .black, location: 0.5),
                            .init(color: .magenta, location: 1.0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: size, height: size)
                    
                    NLinearGradient(
                        stops: [
                            .init(color: .blue, location: 0.5),
                            .init(color: .green, location: 0.75),
                            .init(color: .orange, location: 1.0)
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                    .frame(width: size, height: size)
                }
            }
        }
        .padding(20)
    }
}
#endif
