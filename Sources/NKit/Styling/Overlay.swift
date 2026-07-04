import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

public class NOverlay: BaseView {
    public enum Alignment {
        case topLeading,    top,    topTrailing
        case leading,       center, trailing
        case bottomLeading, bottom, bottomTrailing
    }
    
    private let alignment: Alignment
    internal private(set) weak var mainView: _View?
    
    internal init(
        alignment: Alignment,
        superview: _View,
        subview: _View,
        over: Bool
    ) {
        self.alignment = alignment
        self.mainView = superview
        
        super.init()
        
        self.prepare()
        
        superview.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        if over {
            self.addSubviewAutomatically(superview)
        }
        self.addSubview(subview)
        self.setupSubview(subview)
        if !over {
            self.addSubviewAutomatically(superview)
        }
    }
    
    private func setupSubview(_ subview: _View) {
        NDimmension.width.constraint(superview: self, subview: subview, priority: .dragThatCannotResize).isActive = true
        NDimmension.height.constraint(superview: self, subview: subview, priority: .dragThatCannotResize).isActive = true
        
        switch alignment {
        case .topLeading, .top, .topTrailing:
            NEdge.top.constraint(superview: self, subview: subview).isActive = true
        default:
            break
        }
        
        switch alignment {
        case .leading, .center, .trailing:
            self.centerYAnchor.constraint(equalTo: subview.centerYAnchor).isActive = true
        default:
            break
        }
        
        switch alignment {
        case .bottomLeading, .bottom, .bottomTrailing:
            NEdge.bottom.constraint(superview: self, subview: subview).isActive = true
        default:
            break
        }
        
        switch alignment {
        case .topLeading, .leading, .bottomLeading:
            NEdge.leading.constraint(superview: self, subview: subview).isActive = true
        default:
            break
        }
        
        switch alignment {
        case .top, .center, .bottom:
            self.centerXAnchor.constraint(equalTo: subview.centerXAnchor).isActive = true
        default:
            break
        }
        
        switch alignment {
        case .topTrailing, .trailing, .bottomTrailing:
            NEdge.trailing.constraint(superview: self, subview: subview).isActive = true
        default:
            break
        }
    }
}

extension _View {
    public func overlay(
        _ alignment: NOverlay.Alignment = .center,
        _ subview: () -> _View
    ) -> _View {
        self.overlay(alignment, subview())
    }
    
    public func overlay(
        _ alignment: NOverlay.Alignment = .center,
        _ subview: _View
    ) -> _View {
        NOverlay(
            alignment: alignment,
            superview: self,
            subview: subview,
            over: true
        )
    }
    
    public func background(
        _ alignment: NOverlay.Alignment = .center,
        _ subview: () -> _View
    ) -> _View {
        self.background(alignment, subview())
    }
    
    public func background(
        _ alignment: NOverlay.Alignment = .center,
        _ subview: _View
    ) -> _View {
        NOverlay(
            alignment: alignment,
            superview: self,
            subview: subview,
            over: false
        )
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    NViewPreview {
        NVStack {
            NColor(.green)
                .frame(width: 100, height: 100)
                .overlay {
                    NColor(.blue.opacity(0.5))
                        .padding(10)
                }
            
            NColor(.green)
                .frame(width: 100, height: 100)
                .overlay {
                    NColor(.blue.opacity(0.5))
                        .frame(width: 120, height: 120)
                }
            
            NColor(.yellow.opacity(0.5))
                .frame(width: 100, height: 100)
                .background {
                    NColor(.red)
                        .padding(10)
                }
            
            NColor(.yellow.opacity(0.5))
                .frame(width: 80, height: 80)
                .padding(10)
                .background {
                    NColor(.red)
                }
        }
        .padding(20)
    }
}

#Preview {
    NViewPreview {
        NVStack {
            NColor.blue
                .frame(width: 200, height: 200)
                .overlay {
                    NImage(_Image(named: "lena", in: .module)!)
                        .opacity(0.5)
                }
            
            NColor.red
                .opacity(0.5)
                .frame(width: 200, height: 200)
                .background {
                    NImage(_Image(named: "lena", in: .module)!)
                }
            
        }
        .padding(20)
    }
}
#endif
