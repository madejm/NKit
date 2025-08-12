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
            
            let views: [_View] = nView.views(onChange: { [weak self] (range: Range<Int>, changes: [Change<_View>]) in
                guard let self = self else {
                    return
                }
                
                print("🆕 STACK UPDATE START, changes: \(changes.count)")
                
                let start: Int = readyContent.viewCount(upTo: i)
                let replaceRange: Range<Int> = (start + range.lowerBound)..<(start + range.upperBound)
                
                var viewsToRemove: [(view: _View, NAME: String)] = []
                var viewsToInsert: [(index: StackIndex, view: _View, NAME: String)] = []
                
                for change in changes {
                    switch change {
                    case .remove(let at, let count):
                        for r in 0..<count {
                            let atIndex: StackIndex = replaceRange.lowerBound + at + r
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
                            let fromIndex: StackIndex = replaceRange.lowerBound + from + element.offset
                            let toIndex: StackIndex = replaceRange.lowerBound + element.offset + to
                            let NAME1 = element.element.textFieldString
                            
                            let view: _View = self.stack.arrangedSubviews[fromIndex]
                            let NAME = view.textFieldString
                            
                            print("    MOVING \(NAME1) (\(NAME)), \(fromIndex) -> \(toIndex)")
                            
                            viewsToRemove.append((view, NAME))
                            viewsToInsert.append((index: toIndex, view: view, NAME: NAME))
                        }
                    case .insert(let at, let views):
                        for element in views.enumerated() {
                            let atIndex: StackIndex = replaceRange.lowerBound + element.offset + at
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
            })
            
            arrangedSubviews.append(contentsOf: views)
        }
        
        for subview in arrangedSubviews {
            self.stack.addArrangedSubview(subview)
        }
    }
}


extension _View {
    var textFieldString: String {
        let tv = self as? NSTextField
        let sv: String = tv?.stringValue ?? ""
        return sv
    }
}

extension NView {
    var debugStringValues: [Any] {
        if let d = self as? _View {
            return [d.textFieldString]
        } else if let a = self as? [NView] {
            return ["ARR:", a.flatMap {
                $0.debugStringValues
            }]
        } else if let n = self as? AnyNForEach {
            return ["FOREACH \(n.DEBUG_LABEL):", n.NONCACHABLE_DEBUG_CONTENT
                .debugStringValues ]
        } else {
            fatalError()
        }
    }
}

extension ViewStack {
    func printStack() {
        print("CURRENT STACK:")
        
        for i in 0..<self.stack.arrangedSubviews.count {
            let ar = self.stack.arrangedSubviews[i]
            let tf = ar as? NSTextField
            let sv = tf?.stringValue
            print("\(i): \(sv ?? "")")
        }
    }
}

#Preview {
    NSViewPreview {
        
        let state: NState<[Int]> = .init(wrappedValue: [0, 1])
        let binding: NBinding<[Int]> = state.projectedValue
        
        let nestedState: NState<[String]> = .init(wrappedValue: ["A"])
        let nestedBinding: NBinding<[String]> = nestedState.projectedValue
        
        let rootView = NVStack {
            NForEach(binding) { (outer: NGet<Int?>) in
                NForEach(nestedBinding) { (inner: NGet<String?>) in
                    if let value1 = outer.wrappedValue,
                       let value2 = inner.wrappedValue {
                        {
                            let text = "\(value1) \(value2)"
                            return Text(text)
                        }()
                    }
                }
            }
        }
        
        Task {
            await sleepe()
            rootView.anim {
                nestedBinding.wrappedValue.append("B")
            }
            await sleepe()
            rootView.anim {
                nestedBinding[1].wrappedValue = "C"
            }
            await sleepe()
            rootView.anim {
                binding[1].wrappedValue = 2
            }
        }
        
        return rootView
    }
    .frame(width: 200, height: 200)
}

func sleepe() async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
}

extension NSView {
    func anim(_ block: @escaping () -> Void) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            block()
            self.layoutSubtreeIfNeeded()
        }
    }
}
