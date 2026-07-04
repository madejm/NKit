//
//  NGet+StringTests.swift
//  NKit
//
//  Created by Mateusz Madej on 04/07/2026.
//

import Testing
@testable import NKit

@Suite("NGet+String Tests")
@MainActor
struct NGetStringTests {
    @Test func testGet() {
        let val1: NState<String> = .init(wrappedValue: "Val 1")
        let val2: NState<String> = .init(wrappedValue: "Val 2")
        let subject: NGet<String> = "Result: \(val1), \(val2)"
        var changedValue: String?
        
        subject.onChange {
            changedValue = $0
        }
        
        #expect(subject.wrappedValue == "Result: Val 1, Val 2")
        
        val1.wrappedValue = "This"
        #expect(subject.wrappedValue == "Result: This, Val 2")
        #expect(changedValue == "Result: This, Val 2")
        
        val2.wrappedValue = "Changed"
        #expect(subject.wrappedValue == "Result: This, Changed")
        #expect(changedValue == "Result: This, Changed")
    }
}
