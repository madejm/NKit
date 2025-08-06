//
//  NBindingTests.swift
//  NKit
//
//  Created by Mejdej on 06/08/2025.
//

import Testing
@testable import NKit

@Suite("NBindingTests")
@MainActor
struct NBindingTests {
    @Test func testBinding() {
        nonisolated(unsafe) let value: NValue<Int> = .init(wrappedValue: 0)
        
        let binding: NBinding<Int> = value.binding
        
        let childBinding: NBinding<String> = binding.map(
            up: {
                String($0)
            },
            down: {
                Int($0)!
            }
        )
        var onChangeCalls: Int = 0
        var changedValue: Int? = nil
        var onChangeChildCalls: Int = 0
        var changedChildValue: String? = nil
        
        binding.onChange {
            onChangeCalls += 1
            changedValue = $0
        }
        childBinding.onChange {
            onChangeChildCalls += 1
            changedChildValue = $0
        }
        
        #expect(binding.wrappedValue == 0)
        #expect(childBinding.wrappedValue == "0")
        #expect(onChangeCalls == 0)
        #expect(changedValue == nil)
        #expect(onChangeChildCalls == 0)
        #expect(changedChildValue == nil)
        
        binding.wrappedValue = 1
        #expect(binding.wrappedValue == 1)
        #expect(childBinding.wrappedValue == "1")
        #expect(onChangeCalls == 1)
        #expect(changedValue == 1)
        #expect(onChangeChildCalls == 1)
        #expect(changedChildValue == "1")
        
        childBinding.wrappedValue = "2"
        #expect(binding.wrappedValue == 2)
        #expect(childBinding.wrappedValue == "2")
        #expect(onChangeCalls == 2)
        #expect(changedValue == 2)
        #expect(onChangeChildCalls == 2)
        #expect(changedChildValue == "2")
    }
    
    @Test func testBindingDynamicMember() {
        struct TestStruct: Equatable {
            var number: Int = 0
        }
        
        nonisolated(unsafe) let value: NValue<TestStruct> = .init(wrappedValue: .init())
        
        let binding: NBinding<TestStruct> = value.binding
        
        #expect(binding.wrappedValue.number == 0)
        #expect(binding.number.wrappedValue == 0)
        
        value.wrappedValue.number = 1
        #expect(binding.wrappedValue.number == 1)
        #expect(binding.number.wrappedValue == 1)
        
        binding.number.wrappedValue = 2
        #expect(binding.wrappedValue.number == 2)
        #expect(binding.number.wrappedValue == 2)
    }
    
    @Test func testBindingOptionalValue() {
        nonisolated(unsafe) let value: NValue<[Int]> = .init(wrappedValue: [1, 2])
        
        let binding: NBinding<[Int]> = value.binding
        
        let bindingAtIndex: NBinding<Int?> = binding.value(index: 1)
        
        #expect(binding.wrappedValue == [1, 2])
        #expect(bindingAtIndex.wrappedValue == 2)
        
        bindingAtIndex.wrappedValue = 3
        #expect(binding.wrappedValue == [1, 3])
        
        binding.wrappedValue = [1, 4, 5]
        #expect(bindingAtIndex.wrappedValue == 4)
        
        bindingAtIndex.wrappedValue = nil
        #expect(binding.wrappedValue == [1, 4, 5])
        
        binding.wrappedValue = [1]
        #expect(bindingAtIndex.wrappedValue == nil)
        
        bindingAtIndex.wrappedValue = 2
        #expect(binding.wrappedValue == [1])
    }
}
