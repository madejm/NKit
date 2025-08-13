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
                    
//                    var viewsToRemove: [(view: _View, NAME: String)] = []
//                    var viewsToInsert: [(index: StackIndex, view: _View, NAME: String)] = []
                    var viewsToRemove: [_View] = []
                    var viewsToInsert: [(index: StackIndex, view: _View)] = []
                    
                    for change in changes {
                        switch change {
                        case .remove(let at, let count):
                            for r in 0..<count {
                                let atIndex: StackIndex = replaceStart + at + r
                                let view: _View = self.stack.arrangedSubviews[atIndex]
//                                let NAME = view.textFieldString
                                
                                let NAME: String = view.mirrorDescription
                                print("    REMOVING \(NAME), at: \(atIndex)")
//                                print("    REMOVING at \(atIndex)")
//                                viewsToRemove.append((view, NAME))
                                viewsToRemove.append(view)
                            }
                        case .keep(let views):
                            for view in views {
                                let NAME: String = view.mirrorDescription
                                print("    KEEPING \(NAME)")
//                                print("    KEEPING \(view.textFieldString)")
                            }
                        case .move(let from, let to, let views):
                            for element in views.enumerated() {
                                let fromIndex: StackIndex = replaceStart + from + element.offset
                                let toIndex: StackIndex = replaceStart + element.offset + to
//                                let NAME1 = element.element.textFieldString
                                
                                let view: _View = self.stack.arrangedSubviews[fromIndex]
//                                let NAME = view.textFieldString
                                
                                let NAME: String = view.mirrorDescription
                                print("    MOVING (\(NAME)), \(fromIndex) -> \(toIndex)")
//                                print("    MOVING \(NAME1) (\(NAME)), \(fromIndex) -> \(toIndex)")
//                                print("    MOVING \(fromIndex) -> \(toIndex)")
                                
//                                viewsToRemove.append((view, NAME))
//                                viewsToInsert.append((index: toIndex, view: view, NAME: NAME))
                                viewsToRemove.append(view)
                                viewsToInsert.append((index: toIndex, view: view))
                            }
                        case .insert(let at, let views):
                            for element in views.enumerated() {
                                let atIndex: StackIndex = replaceStart + element.offset + at
//                                let NAME1 = element.element.textFieldString
                                
                                let view: _View = element.element
//                                let NAME = view.textFieldString
                                
//                                let NAME: String = String(describing: Mirror(reflecting: view))
//                                let NAME: String = view.debugDescription
                                let NAME: String = view.mirrorDescription
                                print("    INSERTING (\(NAME)), at \(atIndex)")
//                                print("    INSERTING \(NAME1) (\(NAME)), at \(atIndex)")
//                                print("    INSERTING at \(atIndex)")
                                
//                                viewsToInsert.append((index: atIndex, view: view, NAME: NAME))
                                viewsToInsert.append((index: atIndex, view: view))
                            }
                        }
                    }
                    
                    self.printStack()
                    for view in viewsToRemove {
//                        let DBG_INDEX: String = self.stack.arrangedSubviews.firstIndex(of: view.view).map { String($0) } ?? "?"
//                        print("removing \(view.view.textFieldString) (\(view.NAME)), at: \(DBG_INDEX)")
                        
                        let DBG_INDEX: String = self.stack.arrangedSubviews.firstIndex(of: view).map { String($0) } ?? "?"
                        let NAME: String = view.mirrorDescription
                        
                        print("removing (\(NAME)), at: \(DBG_INDEX)")
//                        print("removing at: \(DBG_INDEX)")
                        
//                        view.view.removeFromSuperview()
                        view.removeFromSuperview()
                    }
                    
//                    let viewsToInsertSorted: [(index: StackIndex, view: _View, NAME: String)] = viewsToInsert
                    let viewsToInsertSorted: [(index: StackIndex, view: _View)] = viewsToInsert
                        .sorted {
                            $0.index < $1.index
                        }
                    
                    self.printStack()
                    for view in viewsToInsertSorted {
                        let NAME: String = view.view.mirrorDescription
                        print("inserting (\(NAME)), at: \(view.index)")
//                        print("inserting \(view.view.textFieldString) (\(view.NAME)), at: \(view.index)")
//                        print("inserting at: \(view.index)")
                        self.stack.insertArrangedSubview(view.view, at: view.index)
                    }
                    self.printStack()
                }
            )
            
            arrangedSubviews.append(contentsOf: views)
        }
        
        for subview in arrangedSubviews {
            self.stack.addArrangedSubview(subview)
        }
    }
}
