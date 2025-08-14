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

extension ViewStack {
    internal func printStack() {
        #if DEBUG
        print("CURRENT STACK:")
        
        for i in 0..<self.stack.arrangedSubviews.count {
            let ar = self.stack.arrangedSubviews[i]
            let tf = ar as? Text
            #if canImport(AppKit)
            let sv = tf?.stringValue
            #elseif canImport(UIKit)
            let sv = tf?.text
            #endif
            print("\(i): \(sv ?? "")")
        }
        #endif
    }
}
