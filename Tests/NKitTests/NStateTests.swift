//
//  NStateTests.swift
//  NKit
//
//  Created by Mejdej on 06/08/2025.
//

import Testing
@testable import NKit

@Suite("NStateTests")
@MainActor
struct NStateTests {
    @Test func testState() {
        let state: NState<Int> = .init(wrappedValue: 0)
        let binding: NBinding<Int> = state.projectedValue
        var onChangeCalls: Int = 0
        var changedValue: Int? = nil
        
        binding.onChange {
            onChangeCalls += 1
            changedValue = $0
        }
        
        #expect(state.wrappedValue == 0)
        #expect(binding.wrappedValue == 0)
        #expect(onChangeCalls == 0)
        #expect(changedValue == nil)
        
        state.wrappedValue = 1
        #expect(state.wrappedValue == 1)
        #expect(binding.wrappedValue == 1)
        #expect(onChangeCalls == 1)
        #expect(changedValue == 1)
        
        binding.wrappedValue = 2
        #expect(state.wrappedValue == 2)
        #expect(binding.wrappedValue == 2)
        #expect(onChangeCalls == 2)
        #expect(changedValue == 2)
    }
}
