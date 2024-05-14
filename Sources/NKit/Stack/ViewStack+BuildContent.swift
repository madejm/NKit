import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension ViewStack {
    internal func buildContent() {
        for subview in self.stack.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        var arrangedSubviews: [_View] = []
        
        let readyContent = self.content()
        
        for i in 0..<readyContent.count {
            let nView: NView = readyContent[i]
            
            let views: [_View] = nView.views(onChange: { [weak self] range, nForEach in
                guard let self = self else {
                    return
                }
                let newContent = self.content()
                let currentCount: Int = (0..<i)
                    .reduce(into: 0) {
                        $0 += newContent[$1].viewsCount
                    }
                
                let low: Int = currentCount + range.lowerBound
                let upp: Int = currentCount + range.upperBound
                self.replaceViews(at: low...upp, with: nForEach)
            })
            
            arrangedSubviews.append(contentsOf: views)
        }
        
        for subview in arrangedSubviews {
            self.stack.addArrangedSubview(subview)
        }
    }
    
    private func replaceViews(
        at range: ClosedRange<Int>,
        with nForEach: AnyNForEach
    ) {
        for _ in range {
            if self.stack.arrangedSubviews.count <= range.lowerBound {
                fatalError("What da heck")
            }
            let view: _View = self.stack.arrangedSubviews[range.lowerBound]
            view.removeFromSuperview()
        }
        
        let nViews: [NView] = nForEach.forEachViews
        let views: [_View] = nViews.views(onChange: { [weak self] newRange, newNForEach in
            let low: Int = range.lowerBound + newRange.lowerBound
            let upp: Int = range.lowerBound + newRange.upperBound
            self?.replaceViews(at: low...upp, with: newNForEach)
        })
        
        for i in 0..<views.count {
            let view: _View = views[i]
            let index: Int = range.lowerBound + i
            self.stack.insertArrangedSubview(view, at: index)
        }
    }
}
