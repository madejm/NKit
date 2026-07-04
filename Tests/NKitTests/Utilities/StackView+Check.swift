//
//  NSStackView+Check.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

import Testing
@testable import NKit

extension NViewStack {
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
            return copy.removeFirst().asText
        }
        
        let rest: () -> [String?] = {
            copy.map { $0.asText }
        }
        
        subviews(next, rest)
    }
}

extension _View {
    var asText: String? {
        #expect(self is NText)
        let text = self as? NText
        #if canImport(AppKit)
        return text?.stringValue
        #elseif canImport(UIKit)
        return text?.text
        #endif
    }
    
    var asStack: _Stack? {
        #expect(self is NViewStack)
        let viewStack = self as? NViewStack
        return viewStack?.stack
    }
}
