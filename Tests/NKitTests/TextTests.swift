//
//  TextTests.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

import Testing
@testable import NKit

@Suite("TextTests")
@MainActor
final class TextTests {
    var newViewsCreated: Int = 0
    
    func createText(_ get: NGet<String>) -> NText {
        print("✨ Creating view: \(get.wrappedValue)")
        let text = Text(get)
        newViewsCreated += 1
        return text
    }
    
    @Test func testStacks() {
        let state: NState<String> = .init(wrappedValue: "A")
        
        let rootView = NHStack { [unowned self] in
            for i in 1...3 {
                let get: NGet<String> = state.projectedValue.get.map { "Text \($0) \(i)" }
                self.createText(get)
            }
        }
        
        #expect(rootView.stack.subviews.count == 3)
        #expect(newViewsCreated == 3)
        rootView.check { next, rest in
            #expect(next() == "Text A 1")
            #expect(next() == "Text A 2")
            #expect(next() == "Text A 3")
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state.wrappedValue = "B"
        #expect(rootView.stack.subviews.count == 3)
        #expect(newViewsCreated == 0)
        rootView.check { next, rest in
            #expect(next() == "Text B 1")
            #expect(next() == "Text B 2")
            #expect(next() == "Text B 3")
            #expect(rest() == [])
        }
    }
}
