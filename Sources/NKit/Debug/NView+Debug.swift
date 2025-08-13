//
//  NView+Debug.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

extension NView {
    internal var debugStringValues: [Any] {
        #if DEBUG
        if let d = self as? _View {
            return [d.mirrorDescription]
        } else if let a = self as? [NView] {
            return ["ARR:", a.flatMap {
                $0.debugStringValues
            }]
        } else if let n = self as? AnyNForEach {
            return ["FOREACH"]
        } else {
            fatalError()
        }
        #else
        []
        #endif
    }
}

#if DEBUG
extension ViewStack {
    internal func printStack() {
        print("CURRENT STACK:")
        
        for i in 0..<self.stack.arrangedSubviews.count {
            let ar = self.stack.arrangedSubviews[i]
            let tf = ar as? Text
            let sv = tf?.stringValue
            print("\(i): \(sv ?? "")")
        }
    }
}
#endif
