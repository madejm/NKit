import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
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
        subview: _View
    ) {
        self.alignment = alignment
        self.mainView = superview
        
        super.init()
        
        self.prepare()
        
        self.addSubviewAutomatically(superview)
        self.setupSubview(subview)
    }
    
    private func setupSubview(_ subview: _View) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
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
        subview: () -> _View
    ) -> _View {
        NOverlay(
            alignment: alignment,
            superview: self,
            subview: subview()
        )
    }
}
