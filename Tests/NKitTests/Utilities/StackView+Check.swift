//
//  NSStackView+Check.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

import AppKit
import Testing
@testable import NKit

extension ViewStack {
    @MainActor
    func check(
        _ subviews: (
            _ next: () -> String?,
            _ rest: () -> [String?]
        ) -> Void
    ) {
        var copy = self.stack.arrangedSubviews
        
        let next: () -> String? = {
            #expect(!copy.isEmpty)
            
            guard !copy.isEmpty else {
                return nil
            }
            return copy.removeFirst().asText?.stringValue
        }
        
        let rest: () -> [String?] = {
            copy.map { $0.asText?.stringValue }
        }
        
        subviews(next, rest)
    }
    
    func printStack() {
        print("")
        print("STACK:")
        
        for i in 0..<stack.arrangedSubviews.count {
            print("\(i): \(stack.arrangedSubviews[i].asText?.stringValue ?? "")")
        }
    }
}

extension NSView {
    var asText: NSTextField? {
        #expect(self is NSTextField)
        return self as? NSTextField
    }
    
    var asStack: NSStackView? {
        #expect(self is ViewStack)
        let viewStack = self as? ViewStack
        return viewStack?.stack
    }
}
