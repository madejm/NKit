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
        
        let readyContent: [NView] = self.content()
        
        for i in 0..<readyContent.count {
            let nView: NView = readyContent[i]
            
            let views: [_View] = nView.views(onChange: { [weak self] (range: Range<Int>, newViews: [_View]) in
                guard let self = self else {
                    return
                }
                
                let start: Int = readyContent.viewCount(upTo: i)
                let replaceRange: Range<Int> = (start + range.lowerBound)..<(start + range.upperBound)
                
                for _ in replaceRange {
                    guard replaceRange.lowerBound < self.stack.arrangedSubviews.count else {
//                        fatalError("What da heck")
                        continue
                    }
                    let view: _View = self.stack.arrangedSubviews[replaceRange.lowerBound]
                    view.removeFromSuperview()
                }
                
                for newViewIndex in 0..<newViews.count {
                    let newView: _View = newViews[newViewIndex]
                    let newIndex: Int = replaceRange.lowerBound + newViewIndex
                    self.stack.insertArrangedSubview(newView, at: newIndex)
                }
            })
            
            arrangedSubviews.append(contentsOf: views)
        }
        
        for subview in arrangedSubviews {
            self.stack.addArrangedSubview(subview)
        }
    }
}
