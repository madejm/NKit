import Testing
import SwiftUI
@testable import NKit

@Suite("NForEachReplacingTests")
@MainActor
final class NForEachReplacingTests {
    nonisolated(unsafe) let deallocationChecker = DeallocationChecker()
    var newViewsCreated: Int = 0
    
    init() {
    }
    
    deinit {
        let checker = deallocationChecker
        Task { @MainActor in
//            #expect(checker.deallocatedCount == checker.elementsCount)
//            #expect(checker.notDeallocated.isEmpty)
        }
    }
    
    func createText(_ string: String) -> NKit.Text {
        print("✨ Creating view: \(string)")
        let text = Text(string)
        newViewsCreated += 1
        self.deallocationChecker.append(text)
        return text
    }
    
    func createText(_ get: NGet<String?>) -> NKit.Text {
        print("✨ Creating view: \(get.wrappedValue ?? "nil")")
        let text = Text(get)
        newViewsCreated += 1
        self.deallocationChecker.append(text)
        return text
    }
    
    @Test func testNForEachReplacing() {
        let state: NState<[Int]> = .init(wrappedValue: [0, 1, 2, 0])
        let binding: NBinding<[Int]> = state.projectedValue
        
        let rootView = NHStack { [unowned self] in
            NForEach(binding) { (index: NGet<Int?>) in
                if let value = index.wrappedValue {
                    self.createText("\(value)")
                }
            }
        }
        
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 4)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "1")
            #expect(next() == "2")
            #expect(next() == "0")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing 1 with 3")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding[1].wrappedValue = 3
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 1)
//        #expect(deallocationChecker.deallocatedCount == 1)
        rootView.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "3")
            #expect(next() == "2")
            #expect(next() == "0")
            #expect(rest() == [])
        }
        
        print("\n🔧 Swaping 2 and 3")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding.wrappedValue.swapAt(1, 2)
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 0)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "2")
            #expect(next() == "3")
            #expect(next() == "0")
            #expect(rest() == [])
        }
        
        print("\n🔧 Inserting 0")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding.wrappedValue.insert(0, at: 1)
        #expect(rootView.stack.arrangedSubviews.count == 5)
        #expect(newViewsCreated == 1)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "0")
            #expect(next() == "2")
            #expect(next() == "3")
            #expect(next() == "0")
            #expect(rest() == [])
        }
        
        print("\n🔧 Removing 2")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding.wrappedValue.remove(at: 2)
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 0)
//        #expect(deallocationChecker.deallocatedCount == 1)
        rootView.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "0")
            #expect(next() == "3")
            #expect(next() == "0")
            #expect(rest() == [])
        }
    }
    
    @Test func testNForEachReplacingOuterAndNested() {
        let state: NState<[Int]> = .init(wrappedValue: [0, 1])
        let binding: NBinding<[Int]> = state.projectedValue
        
        let nestedState: NState<[String]> = .init(wrappedValue: ["A"])
        let nestedBinding: NBinding<[String]> = nestedState.projectedValue
        
        let rootView = NHStack { [unowned self] in
            NForEach(binding) { (outer: NGet<Int?>) in
                NForEach(nestedBinding) { (inner: NGet<String?>) in
                    if let value1 = outer.wrappedValue, let value2 = inner.wrappedValue {
                        self.createText("\(value1) \(value2)")
                    }
                }
            }
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "1 A")
            #expect(rest() == [])
        }
        
        print("\n🔧 Appending B")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue.append("B")
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(next() == "1 A")
            #expect(next() == "1 B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with C")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue[1] = "C"
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
//        #expect(deallocationChecker.deallocatedCount == 2)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 C")
            #expect(next() == "1 A")
            #expect(next() == "1 C")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing 1 with 2")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding.wrappedValue[1] = 2
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
//        #expect(deallocationChecker.deallocatedCount == 2)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 C")
            #expect(next() == "2 A")
            #expect(next() == "2 C")
            #expect(rest() == [])
        }
        
        print("🔧 Inserting D")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue.insert("D", at: 1)
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 2)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 D")
            #expect(next() == "0 C")
            #expect(next() == "2 A")
            #expect(next() == "2 D")
            #expect(next() == "2 C")
            #expect(rest() == [])
        }
        
        print("🔧 Remove A D C")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue.removeAll()
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
//        #expect(deallocationChecker.deallocatedCount == 6)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        print("🔧 Add B A")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue = ["B", "A"]
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 4)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0 B")
            #expect(next() == "0 A")
            #expect(next() == "2 B")
            #expect(next() == "2 A")
            #expect(rest() == [])
        }
        
        print("🔧 Remove 0 2")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding.wrappedValue.removeAll()
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
//        #expect(deallocationChecker.deallocatedCount == 4)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        print("🔧 Add 1 0")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding.wrappedValue = [1, 0]
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 4)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "1 B")
            #expect(next() == "1 A")
            #expect(next() == "0 B")
            #expect(next() == "0 A")
            #expect(rest() == [])
        }
    }
    
    @Test func testNForEachReplacingOnlyNested() {
        let nestedState: NState<[String]> = .init(wrappedValue: ["A"])
        let nestedBinding: NBinding<[String]> = nestedState.projectedValue
        
        let rootView = NHStack { [unowned self] in
            NForEach([0, 1]) { (outer: Int) in
                NForEach(nestedBinding) { (inner: NGet<String?>) in
                    if let value2 = inner.wrappedValue {
                        self.createText("\(outer) \(value2)")
                    }
                }
            }
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "1 A")
            #expect(rest() == [])
        }
        
        print("\n🔧 Appending B")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue.append("B")
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(next() == "1 A")
            #expect(next() == "1 B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with C")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue[1] = "C"
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
//        #expect(deallocationChecker.deallocatedCount == 2)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 C")
            #expect(next() == "1 A")
            #expect(next() == "1 C")
            #expect(rest() == [])
        }
        
        print("🔧 Inserting D")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue.insert("D", at: 1)
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 2)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 D")
            #expect(next() == "0 C")
            #expect(next() == "1 A")
            #expect(next() == "1 D")
            #expect(next() == "1 C")
            #expect(rest() == [])
        }
        
        print("🔧 Remove A D C")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue.removeAll()
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
//        #expect(deallocationChecker.deallocatedCount == 6)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        print("🔧 Add B A")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        nestedBinding.wrappedValue = ["B", "A"]
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 4)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "0 B")
            #expect(next() == "0 A")
            #expect(next() == "1 B")
            #expect(next() == "1 A")
            #expect(rest() == [])
        }
    }
    
    @Test func testNForEachReplacingWithBindedTexts() {
        let state: NState<[String]> = .init(wrappedValue: ["A", "B"])
        let binding: NBinding<[String]> = state.projectedValue
        
        let rootView = NHStack { [unowned self] in
            NForEach(binding) { (inner: NGet<String?>) in
                self.createText(inner)
            }
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Appending C")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding.wrappedValue.append("C")
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 3)
        #expect(newViewsCreated == 1)
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "B")
            #expect(next() == "C")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with D")
        newViewsCreated = 0
//        deallocationChecker.deallocatedCount = 0
        binding.wrappedValue[1] = "D"
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 3)
        #expect(newViewsCreated == 1) // 0
        #expect(deallocationChecker.deallocatedCount == 0)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "D")
            #expect(next() == "C")
            #expect(rest() == [])
        }
    }
}
