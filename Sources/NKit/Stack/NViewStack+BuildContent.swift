import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import SwiftUI

extension NViewStack {
    internal func buildContent() {
        for subview in self.stack.arrangedSubviews {
            self.stack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        var arrangedSubviews: [_View] = []
        
        let readyContent: [NView] = self.content()
        
        self.retainedDynamicViews = readyContent.flatMapCacheables()
        
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
                    
                    var viewsToRemove: [_View] = []
                    var viewsToInsert: [(index: StackIndex, view: _View)] = []
                    
                    for change in changes {
                        switch change {
                        case .remove(let at, let count):
                            for r in 0..<count {
                                let atIndex: StackIndex = replaceStart + at + r
                                let view: _View = self.stack.arrangedSubviews[atIndex]
                                
                                print_debug("    REMOVING", view.mirrorDescription, "at:", atIndex)
                                viewsToRemove.append(view)
                            }
                        case .keep(let views):
                            for view in views {
                                print_debug("    KEEPING", view.mirrorDescription)
                            }
                        case .move(let from, let to, let views):
                            for element in views.enumerated() {
                                let fromIndex: StackIndex = replaceStart + from + element.offset
                                let toIndex: StackIndex = replaceStart + element.offset + to
//                                let NAME1 = element.element.textFieldString
                                let view: _View = self.stack.arrangedSubviews[fromIndex]
                                view.skipParentChanges += 2
                                
                                print_debug("    MOVING", view.mirrorDescription, fromIndex, "->", toIndex)
                                viewsToRemove.append(view)
                                viewsToInsert.append((index: toIndex, view: view))
                            }
                        case .insert(let at, let views):
                            for element in views.enumerated() {
                                let atIndex: StackIndex = replaceStart + element.offset + at
//                                let NAME1 = element.element.textFieldString
                                let view: _View = element.element
                                
                                print_debug("    INSERTING", view.mirrorDescription, "at:", atIndex)
                                viewsToInsert.append((index: atIndex, view: view))
                            }
                        }
                    }
                    
//                    self.printStack()
                    for view in viewsToRemove {
                        print_debug("removing", view.mirrorDescription, "at:", self.stack.arrangedSubviews.firstIndex(of: view).map { String($0) } ?? "?")
                        
                        self.stack.removeArrangedSubview(view)
                        view.removeFromSuperview()
                    }
                    
                    let viewsToInsertSorted: [(index: StackIndex, view: _View)] = viewsToInsert
                        .sorted {
                            $0.index < $1.index
                        }
                    
//                    self.printStack()
                    for view in viewsToInsertSorted {
                        print_debug("inserting", view.view.mirrorDescription, "at:", view.index)
                        
                        self.stack.insertArrangedSubview(view.view, at: view.index)
                    }
                    
                    self.stack.updateDimmensionConstraints()
//                    self.printStack()
                    
                    if let animation: NAnimation = self.currentAnimation {
                        self.layoutIfNeeded()
                        self.stack.layoutIfNeeded()
                    }
                }
            )
            
            arrangedSubviews.append(contentsOf: views)
        }
        
        for subview in arrangedSubviews {
            self.stack.addArrangedSubview(subview)
        }
        self.stack.updateDimmensionConstraints()
    }
}

extension Array where Element == NView {
    fileprivate func flatMapCacheables() -> [NCacheable] {
        self.flatMap {
            if let cacheable = $0 as? NCacheable {
                return [cacheable]
            } else if let array = $0 as? [NView] {
                return array.flatMapCacheables()
            } else {
                return []
            }
        }
    }
}
