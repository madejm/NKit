import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

open class NDivider: BaseView {
    
    fileprivate var constraint: NSLayoutConstraint?
    
    public override init() {
        super.init()
        
        backgroundColor = _Color.white
    }
}

extension NDivider: NLayoutDirectionable {
    public func didChangeLayoutDirection(_ layoutDirection: NLayoutDirection) {
        constraint?.isActive = false
        
        let dimmension: NDimmension
        
        switch layoutDirection {
        case .horizontal:
            dimmension = .width
        case .vertical:
            dimmension = .height
        @unknown default:
            return
        }
        
        constraint = dimmension.constraint(view: self, value: 1)
        constraint?.isActive = true
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState var ok1: Bool = true
    @Previewable @State var ok2: Bool = true
    
    HStack {
        VStack {
            Toggle("", isOn: $ok2)
                .toggleStyle(.switch)
            
            HStack {
                if ok2 {
                    Color.yellow
                    
                    Divider()
                        .padding(.vertical, 8)
                        .background(.red)
                }
                
                Color.orange
                
                Divider()
                    .background(.gray)
                
                Color(.red)
            }
            .background(.white)
            
            Divider()
            
            Color.green
        }
        .background(.gray)
        .padding(20)
        
        NViewPreview {
            NVStack(hugging: .resize) {
                NSwitch($ok1)
                
                NHStack {
                    NIf($ok1) {
                        NColor(.yellow)
                        
                        NDivider()
                            .padding(.vertical, 8)
                            .background(.red)
                    }
                    
                    NColor(.orange)
                    
                    NDivider()
                        .background(.gray)
                    
                    NColor(.red)
                }
                .background(.white)
                
                NDivider()
                
                NColor(.green)
            }
            .background(.gray)
            .padding(20)
        }
    }
}
#endif
