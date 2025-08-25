//
//  NIfTests.swift
//  NKit
//
//  Created by Mejdej on 25/08/2025.
//

import Testing
@testable import NKit

@Suite("NIfTests")
@MainActor
final class NIfTests {
    nonisolated(unsafe) let deallocationChecker = DeallocationChecker()
    var newViewsCreated: Int = 0
    
    func createText(_ string: String) -> NKit.Text {
        print("✨ Creating static view: \(string)")
        let text = Text(string)
        newViewsCreated += 1
        self.deallocationChecker.append(text)
        return text
    }
    
    @Test func testIf() async {
        @NState<[Int]> var state = [1]
        let binding: NBinding<[Int]> = $state
        let get: NGet<[Int]> = binding.get
        
        let rootView = NHStack { [unowned self] in
            NForEach(get) { (value: NGet<Int>) in
                if (value.wrappedValue > 0) {
                    self.createText("Content \(value.wrappedValue)")
                }
            }
        }
        
        #expect(rootView.stack.arrangedSubviews.count == 1)
        #expect(newViewsCreated == 1)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "Content 1")
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state = [0]
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state = [2]
        #expect(rootView.stack.arrangedSubviews.count == 1)
        #expect(newViewsCreated == 1)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "Content 2")
            #expect(rest() == [])
        }
    }
    
    @Test func testNIfSimpleBool() async {
        @NState<Bool> var state = true
        let binding: NBinding<Bool> = $state
        let get: NGet<Bool> = binding.get
        
        let rootView = NHStack { [unowned self] in
            NIf(get) {
                self.createText("Content")
            }
        }
        
        #expect(rootView.stack.arrangedSubviews.count == 1)
        #expect(newViewsCreated == 1)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "Content")
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state = false
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state = true
        #expect(rootView.stack.arrangedSubviews.count == 1)
        #expect(newViewsCreated == 1)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "Content")
            #expect(rest() == [])
        }
    }
    
    @Test func testNIfComplexBool() async {
        @NState<Bool> var state1 = true
        @NState<Bool> var state2 = false
        @NState<Bool> var state3 = true
        let get1: NGet<Bool> = $state1.get
        let get2: NGet<Bool> = $state2.get
        let get3: NGet<Bool> = $state3.get
        
        let rootView = NHStack { [unowned self] in
            NIf(get1 || (get2 && !get3)) {
                self.createText("Content")
            }
        }
        
        #expect(rootView.stack.arrangedSubviews.count == 1)
        #expect(newViewsCreated == 1)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "Content")
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state1 = false
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state2 = true
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state3 = false
        #expect(rootView.stack.arrangedSubviews.count == 1)
        #expect(newViewsCreated == 1)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "Content")
            #expect(rest() == [])
        }
    }
    
    @Test func testNIfArithmetic() async {
        @NState<Int> var state = 1
        let binding: NBinding<Int> = $state
        let get: NGet<Int> = binding.get
        
        let rootView = NHStack { [unowned self] in
            NIf(get > 0) {
                NForEach([1, 2]) {
                    self.createText("True \($0)")
                }
            } else: {
                self.createText("False")
            }
        }
        
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "True 1")
            #expect(next() == "True 2")
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state = 0
        #expect(rootView.stack.arrangedSubviews.count == 1)
        #expect(newViewsCreated == 1)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "False")
            #expect(rest() == [])
        }
        
        newViewsCreated = 0
        state = 2
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        await #expect(deallocationChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        rootView.check { next, rest in
            #expect(next() == "True 1")
            #expect(next() == "True 2")
            #expect(rest() == [])
        }
    }
}
