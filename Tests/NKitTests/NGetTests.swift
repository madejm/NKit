//
//  NGetTests.swift
//  NKit
//
//  Created by Mejdej on 06/08/2025.
//

import Testing
@testable import NKit

@Suite("NGetTests")
@MainActor
struct NGetTests {
    @Test func testGet() {
        nonisolated(unsafe) let value: NValue<Int> = .init(wrappedValue: 0)
        
        let binding: NBinding<Int> = .init(
            get: {
                value.wrappedValue
            },
            set: {
                value.wrappedValue = $0
            }
        )
        let childGet: NGet<Int> = binding.get
        let childMappedGet: NGet<String> = childGet.map(
            up: {
                String($0)
            }
        )
        
        var onChangeCalls: Int = 0
        var changedValue: Int? = nil
        var onChangeChildCalls: Int = 0
        var changedChildValue: Int? = nil
        var onChangeChildMappedCalls: Int = 0
        var changedChildMappedValue: String? = nil
        
        binding.onChange {
            onChangeCalls += 1
            changedValue = $0
        }
        childGet.onChange {
            onChangeChildCalls += 1
            changedChildValue = $0
        }
        childMappedGet.onChange {
            onChangeChildMappedCalls += 1
            changedChildMappedValue = $0
        }
        
        #expect(binding.wrappedValue == 0)
        #expect(childGet.wrappedValue == 0)
        #expect(childMappedGet.wrappedValue == "0")
        #expect(onChangeCalls == 0)
        #expect(changedValue == nil)
        #expect(onChangeChildCalls == 0)
        #expect(changedChildValue == nil)
        #expect(onChangeChildMappedCalls == 0)
        #expect(changedChildMappedValue == nil)
        
        binding.wrappedValue = 1
        #expect(binding.wrappedValue == 1)
        #expect(childGet.wrappedValue == 1)
        #expect(childMappedGet.wrappedValue == "1")
        #expect(onChangeCalls == 1)
        #expect(changedValue == 1)
        #expect(onChangeChildCalls == 1)
        #expect(changedChildValue == 1)
        #expect(onChangeChildMappedCalls == 1)
        #expect(changedChildMappedValue == "1")
    }
    
    @Test func testCombine() {
        let state1: NState<String> = .init(wrappedValue: "1")
        let state2: NState<String> = .init(wrappedValue: "2")
        let get: NGet<String> = .combine(
            state1.projectedValue,
            state2.projectedValue,
            operation: { one, two in
                "\(one) \(two)"
            }
        )
        
        var onChangeCalls: Int = 0
        var changedValue: String? = nil
        
        get.onChange {
            onChangeCalls += 1
            changedValue = $0
        }
        
        #expect(state1.wrappedValue == "1")
        #expect(state2.wrappedValue == "2")
        #expect(get.wrappedValue == "1 2")
        #expect(onChangeCalls == 0)
        #expect(changedValue == nil)
        
        state1.wrappedValue = "ONE"
        #expect(state1.wrappedValue == "ONE")
        #expect(state2.wrappedValue == "2")
        #expect(get.wrappedValue == "ONE 2")
        #expect(onChangeCalls == 1)
        #expect(changedValue == "ONE 2")
        
        state2.wrappedValue = "TWO"
        #expect(state1.wrappedValue == "ONE")
        #expect(state2.wrappedValue == "TWO")
        #expect(get.wrappedValue == "ONE TWO")
        #expect(onChangeCalls == 2)
        #expect(changedValue == "ONE TWO")
    }
    
    @Test func testGetDynamicMember() {
        struct TestStruct: Equatable {
            var number: Int = 0
        }
        
        nonisolated(unsafe) let value: NValue<TestStruct> = .init(wrappedValue: .init())
        
        let get: NGet<TestStruct> = .init(
            get: {
                value.wrappedValue
            }
        )
        
        #expect(get.wrappedValue.number == 0)
        #expect(get.number.wrappedValue == 0)
        
        value.wrappedValue.number = 1
        
        #expect(get.wrappedValue.number == 1)
        #expect(get.number.wrappedValue == 1)
    }
    
    @Test func testCollectionIndex() {
        let state: NState<[String]> = .init(wrappedValue: ["A", "B", "C"])
        let get: NGet<[String]> = state.projectedValue.get
        
        let newGet: NGet<String> = get[1]
        
        #expect(newGet.wrappedValue == "B")
        
        state.wrappedValue.remove(at: 1)
        #expect(newGet.wrappedValue == "C")
        
        state.wrappedValue.remove(at: 1)
    }
    
    @Test func testCollectionIndexOptional() {
        let state: NState<[String]> = .init(wrappedValue: ["A", "B", "C"])
        let get: NGet<[String]> = state.projectedValue.get
        
        let newGet: NGet<String?> = get[1]
        
        #expect(newGet.wrappedValue == "B")
        
        state.wrappedValue.remove(at: 1)
        #expect(newGet.wrappedValue == "C")
        
        state.wrappedValue.remove(at: 1)
        #expect(newGet.wrappedValue == nil)
    }
}
