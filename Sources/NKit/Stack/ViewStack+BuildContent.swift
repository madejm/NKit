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
        
        for i in 0..<readyContent.count {
            let nView: NView = readyContent[i]
            
//            let currentCount: Int = arrangedSubviews.count
            
            nView.setParent(readyContent)
            
            let views: [_View] = nView.views(
                onChange: { [weak self] (changeOffset: Int, changes: [NChange<_View>]) in
                    guard let self = self else {
                        return
                    }
                    
                    print("🆕 STACK UPDATE START, changes: \(changes.count)")
                    
//                    let start: Int = self.content().viewCount(upTo: i)
                    let start: Int = readyContent.viewCount(upTo: i)
                    let replaceStart: Int = start + changeOffset
                    
                    var viewsToRemove: [(view: _View, NAME: String)] = []
                    var viewsToInsert: [(index: StackIndex, view: _View, NAME: String)] = []
                    
                    for change in changes {
                        switch change {
                        case .remove(let at, let count):
                            for r in 0..<count {
                                let atIndex: StackIndex = replaceStart + at + r
                                let view: _View = self.stack.arrangedSubviews[atIndex]
                                let NAME = view.textFieldString
                                
                                print("    REMOVING \(NAME), at: \(atIndex)")
                                viewsToRemove.append((view, NAME))
                            }
                        case .keep(let views):
                            for view in views {
                                print("    KEEPING \(view.textFieldString)")
                            }
                        case .move(let from, let to, let views):
                            for element in views.enumerated() {
                                let fromIndex: StackIndex = replaceStart + from + element.offset
                                let toIndex: StackIndex = replaceStart + element.offset + to
                                let NAME1 = element.element.textFieldString
                                
                                let view: _View = self.stack.arrangedSubviews[fromIndex]
                                let NAME = view.textFieldString
                                
                                print("    MOVING \(NAME1) (\(NAME)), \(fromIndex) -> \(toIndex)")
                                
                                viewsToRemove.append((view, NAME))
                                viewsToInsert.append((index: toIndex, view: view, NAME: NAME))
                            }
                        case .insert(let at, let views):
                            for element in views.enumerated() {
                                let atIndex: StackIndex = replaceStart + element.offset + at
                                let NAME1 = element.element.textFieldString
                                
                                let view: _View = element.element
                                let NAME = view.textFieldString
                                
                                print("    INSERTING \(NAME1) (\(NAME)), at \(atIndex)")
                                
                                viewsToInsert.append((index: atIndex, view: view, NAME: NAME))
                            }
                        }
                    }
                    
                    printStack()
                    for view in viewsToRemove {
                        let DBG_INDEX: String = self.stack.arrangedSubviews.firstIndex(of: view.view).map { String($0) } ?? "?"
                        print("removing \(view.view.textFieldString) (\(view.NAME)), at: \(DBG_INDEX)")
                        view.view.removeFromSuperview()
                    }
                    
                    let viewsToInsertSorted: [(index: StackIndex, view: _View, NAME: String)] = viewsToInsert
                        .sorted {
                            $0.index < $1.index
                        }
                    
                    printStack()
                    for view in viewsToInsertSorted {
                        print("inserting \(view.view.textFieldString) (\(view.NAME)), at: \(view.index)")
                        self.stack.insertArrangedSubview(view.view, at: view.index)
                    }
                    printStack()
                }
            )
            
            arrangedSubviews.append(contentsOf: views)
        }
        
        for subview in arrangedSubviews {
            self.stack.addArrangedSubview(subview)
        }
    }
}

extension _View {
    func myPosition(inStack stack: ViewStack) -> Int {
        0
    }
}
