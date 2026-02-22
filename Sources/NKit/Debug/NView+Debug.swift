//
//  NView+Debug.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

extension NView {
    internal var debugStringValues: [Any] {
        #if DEBUG
        switch self.unpacked {
        case .view(let view):
            return [view.mirrorDescription]
        case .array(let array):
            return ["ARR:", array.flatMap {
                $0.debugStringValues
            }]
        case .forEach:
            return ["FOREACH"]
        case .if:
            return ["IF"]
        case .otherObject(let object):
            fatalError("Unhandled: \(object)")
        case .other(let nView):
            return ["Other NVIEW"]
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
