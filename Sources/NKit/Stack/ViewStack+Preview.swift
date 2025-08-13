//
//  ViewStack+Preview.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

#if DEBUG && canImport(AppKit) && canImport(SwiftUI)
import AppKit
import SwiftUI

extension NView {
    internal var debugStringValues: [Any] {
        if let d = self as? _View {
            return [d.mirrorDescription]
        } else if let a = self as? [NView] {
            return ["ARR:", a.flatMap {
                $0.debugStringValues
            }]
        } else if let n = self as? AnyNForEach {
//            return ["FOREACH \(n.DEBUG_LABEL):", n.NONCACHABLE_DEBUG_CONTENT
//                .debugStringValues ]
            return ["FOREACH"]
        } else {
            fatalError()
        }
    }
}

extension ViewStack {
    internal func printStack() {
        print("CURRENT STACK:")
        
        for i in 0..<self.stack.arrangedSubviews.count {
            let ar = self.stack.arrangedSubviews[i]
            let tf = ar as? NSTextField
            let sv = tf?.stringValue
            print("\(i): \(sv ?? "")")
        }
    }
}

private func sleepe() async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
}

extension NSView {
    fileprivate func anim(_ block: @escaping () -> Void) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            block()
            self.layoutSubtreeIfNeeded()
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
            await sleepe()
            rootView.anim {
                nestedBinding.wrappedValue.insert("D", at: 1)
            }
        }
        
        return rootView
    }
    .frame(width: 200, height: 200)
}
#endif
