import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

@MainActor
public struct NAnimation {
    public let duration: TimeInterval
    public let timingFunctionName: CAMediaTimingFunctionName
    
    public var timingFunction: CAMediaTimingFunction {
        .init(name: timingFunctionName)
    }
    
    private init(
        duration: TimeInterval = 0.3,
        timingFunctionName: CAMediaTimingFunctionName = .default
    ) {
        self.duration = duration
        self.timingFunctionName = timingFunctionName
    }
    
    public static let `default`: NAnimation = .init()
    
    public static let linear: NAnimation = .init(timingFunctionName: .linear)
    
    public static func linear(duration: TimeInterval) -> NAnimation {
        .init(duration: duration, timingFunctionName: .linear)
    }
    
    public static let easeIn: NAnimation = .init(timingFunctionName: .easeIn)
    
    public static func easeIn(duration: TimeInterval) -> NAnimation {
        .init(duration: duration, timingFunctionName: .easeIn)
    }
    
    public static let easeOut: NAnimation = .init(timingFunctionName: .easeOut)
    
    public static func easeOut(duration: TimeInterval) -> NAnimation {
        .init(duration: duration, timingFunctionName: .easeOut)
    }
    
    public static let easeInOut: NAnimation = .init(timingFunctionName: .easeInEaseOut)
    
    public static func easeInOut(duration: TimeInterval) -> NAnimation {
        .init(duration: duration, timingFunctionName: .easeInEaseOut)
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0)
#Preview {
    @Previewable @NState var isOn: Bool = false
    let text: NBinding<String> = $isOn.map(
        up: {
            $0 ? "Toggle ON" : "Toggle OFF"
        },
        down: {
            $0 == "Toggle ON"
        }
    )
    
    let animation: NAnimation = .easeInOut(duration: 1.0)
//    let animation: NAnimation = .default
    
    NViewPreview {
        NVStack {
            NButton(text) {
                isOn.toggle()
            }
            .animation(nil)
            .background(.red.opacity(0.3))
            
            NButton(text) {
                nWithAnimation(animation) {
                    isOn.toggle()
                }
            }
            .animation(.easeIn(duration: 0.3))
            .background(.blue.opacity(0.3))
            
            NSegmentedControl(
                selection: $isOn.map(
                    up: { $0 ? 0 : 1 },
                    down: { $0 == 0 }
                ).setsAnimation(),
                labels: $isOn.map(up: {
                    $0 ? ["Value 3", "Value 4"] : ["Value 1", "Value 2"]
                })
            )
            
            NSegmentedControl(
                selection: $isOn.map(
                    up: { $0 ? 0 : 1 },
                    down: { $0 == 0 }
                ).setsAnimation(),
                images: $isOn.map(up: {
                    ($0 ? ["car", "airplane"] : ["bus", "ferry"]).map {
                        _Image(systemName: $0)!
                    }
                })
            )
            
            NText(text)
                .background(.yellow.opacity(0.3))
            
            NInput(text)
                .background(.yellow.opacity(0.3))
                .frame(height: 24)
            
            NImage($isOn.map(up: {
                _Image(systemName: $0 ? "car" : "airplane")!
            }))
            .background(.yellow.opacity(0.3))
            .frame(width: 24, height: 24)
            
            NStepper($isOn.map(
                up: { $0 ? 1 : 0 },
                down: { $0 == 1 }
            ).setsAnimation(), range: 0...1)
            .background(.yellow.opacity(0.3))
            
            NSwitch($isOn.setsAnimation())
                .disabled($isOn)
                .background(.yellow.opacity(0.3))
            
            NCheckbox(
                title: text.get,
                state: $isOn.setsAnimation()
            )
            .background(.yellow.opacity(0.3))
            
            NColor(.green)
                .opacity($isOn.map(up: {
                    $0 ? 0.5 : 1
                }))
                .frame(width: $isOn.map(up: {
                    $0 ? 100 : 50
                }))
                .frame(height: 50)
            
            NHStack {
                NColor(.red)
                    .frame(width: 100)
                
                NIf($isOn) {
                    NColor(.blue)
                        .frame(width: 100)
                }
            }
            .background(.yellow.opacity(0.3))
            .frame(height: 50)
            
            NHStack {
                NColor(.orange)
                    .frame(width: 100)
                
                NColor(.green)
                    .frame(width: 100)
                    .hidden(!$isOn)
            }
            .background(.yellow.opacity(0.3))
            .frame(height: 50)
        }
        .frame(width: 300)
        .background(.gray)
    }
}
#endif
