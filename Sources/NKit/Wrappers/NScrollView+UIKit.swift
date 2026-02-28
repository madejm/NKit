import Foundation
#if canImport(UIKit)
import UIKit

open class NScrollView: UIScrollView {

    public init(
        axes: Axis = .vertical,
        showsIndicators: Bool = true,
        _ content: UIView
    ) {
        super.init(frame: .zero)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
        
        NSLayoutConstraint.activate {
            NEdge.Set.all.constraints(superview: self.contentLayoutGuide, subview: content)
            
            if !axes.contains(.horizontal) {
                NEdge.Set.horizontal.constraints(superview: self.frameLayoutGuide, subview: content)
            }
            
            if !axes.contains(.vertical) {
                NEdge.Set.vertical.constraints(superview: self.frameLayoutGuide, subview: content)
            }
        }
        
        self.showsHorizontalScrollIndicator = showsIndicators
        self.showsVerticalScrollIndicator = showsIndicators
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
