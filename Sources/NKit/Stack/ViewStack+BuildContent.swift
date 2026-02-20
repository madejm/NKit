import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import SwiftUI

extension ViewStack {
    internal func buildContent() {
        for subview in self.stack.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        var arrangedSubviews: [_View] = []
        
        let readyContent: [NView] = self.content()
        
        self.retainedDynamicViews = readyContent
            .filter {
                $0 is NForEach || $0 is NIf
            }
        
        for i in 0..<readyContent.count {
            let nView: NView = readyContent[i]
            
            nView.setParent(readyContent)
            
            let views: [_View] = nView.views(
                onChange: { [weak self] (changeOffset: Int, changes: [NChange<_View>]) in
                    guard let self = self else {
                        return
                    }
                    
                    print_debug("🆕 STACK UPDATE START, changes:", changes.count)
                    
//                    let start: Int = self.content().viewCount(upTo: i)
//                    let start: Int = readyContent.viewCount(upTo: i)
//                    let replaceStart: Int = start + changeOffset
                    let replaceStart: Int = changeOffset
                    
                    var viewsToRemove: [(view: _View, animated: Bool)] = []
                    var viewsToInsert: [(index: StackIndex, view: _View, animated: Bool)] = []
                    
                    for change in changes {
                        switch change {
                        case .remove(let at, let count, let animated):
                            for r in 0..<count {
                                let atIndex: StackIndex = replaceStart + at + r
                                let view: _View = self.stack.arrangedSubviews[atIndex]
                                
                                print_debug("    REMOVING", view.mirrorDescription, "at:", atIndex)
                                viewsToRemove.append((view: view, animated: animated))
                            }
                        case .keep(let views):
                            for view in views {
                                print_debug("    KEEPING", view.mirrorDescription)
                            }
                        case .move(let from, let to, let views, let animated):
                            for element in views.enumerated() {
                                let fromIndex: StackIndex = replaceStart + from + element.offset
                                let toIndex: StackIndex = replaceStart + element.offset + to
//                                let NAME1 = element.element.textFieldString
                                let view: _View = self.stack.arrangedSubviews[fromIndex]
                                view.skipParentChanges += 2
                                
                                print_debug("    MOVING", view.mirrorDescription, fromIndex, "->", toIndex)
                                viewsToRemove.append((view: view, animated: animated))
                                viewsToInsert.append((index: toIndex, view: view, animated: animated))
                            }
                        case .insert(let at, let views, let animated):
                            for element in views.enumerated() {
                                let atIndex: StackIndex = replaceStart + element.offset + at
//                                let NAME1 = element.element.textFieldString
                                let view: _View = element.element
                                
                                print_debug("    INSERTING", view.mirrorDescription, "at:", atIndex)
                                viewsToInsert.append((index: atIndex, view: view, animated: animated))
                            }
                        }
                    }
                    
//                    self.printStack()
                    for view in viewsToRemove {
                        print_debug("removing", view.view.mirrorDescription, "at:", self.stack.arrangedSubviews.firstIndex(of: view.view).map { String($0) } ?? "?")
                        withAnimation(animate: view.animated) {
                            view.view.removeFromSuperview()
                        }
                    }
                    
                    let viewsToInsertSorted: [(index: StackIndex, view: _View, animated: Bool)] = viewsToInsert
                        .sorted {
                            $0.index < $1.index
                        }
                    
//                    self.printStack()
                    for view in viewsToInsertSorted {
                        print_debug("inserting", view.view.mirrorDescription, "at:", view.index)
                        
                        withAnimation(animate: view.animated) {
                            self.stack.insertArrangedSubview(view.view, at: view.index)
                        }
                    }
//                    self.printStack()
                }
            )
            
            arrangedSubviews.append(contentsOf: views)
        }
        
        for subview in arrangedSubviews {
            self.stack.addArrangedSubview(subview)
        }
    }
}

#if canImport(AppKit)
extension NSView {
    fileprivate func withAnimation(
        animate: Bool = true,
        duration: TimeInterval = 0.3,
        _ block: @escaping () -> Void
    ) {
        if animate, duration > 0.0 {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = duration
                context.allowsImplicitAnimation = true
                block()
                self.layoutSubtreeIfNeeded()
            }
        } else {
            block()
        }
    }
}
#elseif canImport(UIKit)
extension UIView {
    fileprivate func withAnimation(
        animate: Bool = true,
        duration: TimeInterval = 0.3,
        _ block: @escaping () -> Void
    ) {
        if animate, duration > 0.0 {
            UIView.animate(
                withDuration: duration,
                animations: {
                    block()
                }
            )
        } else {
            block()
        }
    }
}
#endif
