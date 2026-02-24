import Testing
import SwiftUI
import FixedArray
@testable import NKit

@Suite("NForEachReplacingTests")
@MainActor
struct NForEachReplacingTests {
    nonisolated(unsafe) let viewChecker = DeallocationChecker()
    nonisolated(unsafe) let dynamicChecker = DeallocationChecker()
    @NValue var newViewsCreated: Int = 0
    
    init() {
    }
    
    func createText(_ string: String) -> NText {
        print("✨ Creating static view: \(string)")
        let text = Text(string)
        newViewsCreated += 1
        self.viewChecker.append(text)
        return text
    }
    
    func createText(_ get: NGet<String>) -> NText {
        print("✨ Creating binded view: \(get.wrappedValue)")
        let text = Text(get)
        newViewsCreated += 1
        self.viewChecker.append(text)
        return text
    }
    
    @Test func testNForEachReplacing() async {
        let state: NState<[Int]> = .init(wrappedValue: [0, 1, 2, 0])
        let binding: NBinding<[Int]> = state.projectedValue
        
        var rootView: NHStack! = NHStack {
            self.createText("Header")
            
            NForEach(binding) { (index: NGet<Int>) in
                self.createText("\(index.wrappedValue)")
            }
            .checkDealloc(in: dynamicChecker)
            
            self.createText("Footer")
        }
        
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 6)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "0")
            #expect(next() == "1")
            #expect(next() == "2")
            #expect(next() == "0")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing 1 with 3")
        newViewsCreated = 0
        binding[1].wrappedValue = 3
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 1)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "0")
            #expect(next() == "3")
            #expect(next() == "2")
            #expect(next() == "0")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Swaping 2 and 3")
        newViewsCreated = 0
        binding.wrappedValue.swapAt(1, 2)
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "0")
            #expect(next() == "2")
            #expect(next() == "3")
            #expect(next() == "0")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Inserting 0")
        newViewsCreated = 0
        binding.wrappedValue.insert(0, at: 1)
        #expect(rootView.stack.arrangedSubviews.count == 7)
        #expect(newViewsCreated == 1)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "0")
            #expect(next() == "0")
            #expect(next() == "2")
            #expect(next() == "3")
            #expect(next() == "0")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Removing 2")
        newViewsCreated = 0
        binding.wrappedValue.remove(at: 2)
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "0")
            #expect(next() == "0")
            #expect(next() == "3")
            #expect(next() == "0")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        rootView = nil
        await #expect(dynamicChecker.getNotDeallocated().count == 0)
    }
    
    @Test func testNForEachReplacingOuterAndNested() async {
        let state: NState<[Int]> = .init(wrappedValue: [0, 1])
        let binding: NBinding<[Int]> = state.projectedValue
        
        let nestedState: NState<[String]> = .init(wrappedValue: ["A"])
        let nestedBinding: NBinding<[String]> = nestedState.projectedValue
        
        var rootView: NHStack! = NHStack {
            self.createText("Header")
            
            NForEach(binding) { (outer: NGet<Int>) in
                self.createText("Header \(outer.wrappedValue)")
                
                NForEach(nestedBinding) { (inner: NGet<String>) in
                    self.createText("\(outer.wrappedValue) \(inner.wrappedValue)")
                }
                .checkDealloc(in: dynamicChecker)
                
                self.createText("Footer \(outer.wrappedValue)")
            }
            .checkDealloc(in: dynamicChecker)
            
            self.createText("Footer")
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 8)
        #expect(newViewsCreated == 8)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Header 0")
            #expect(next() == "0 A")
            #expect(next() == "Footer 0")
            #expect(next() == "Header 1")
            #expect(next() == "1 A")
            #expect(next() == "Footer 1")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Appending B")
        newViewsCreated = 0
        nestedBinding.wrappedValue.append("B")
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 10)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Header 0")
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(next() == "Footer 0")
            #expect(next() == "Header 1")
            #expect(next() == "1 A")
            #expect(next() == "1 B")
            #expect(next() == "Footer 1")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with C")
        newViewsCreated = 0
        nestedBinding.wrappedValue[1] = "C"
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 10)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Header 0")
            #expect(next() == "0 A")
            #expect(next() == "0 C")
            #expect(next() == "Footer 0")
            #expect(next() == "Header 1")
            #expect(next() == "1 A")
            #expect(next() == "1 C")
            #expect(next() == "Footer 1")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing 1 with 2")
        newViewsCreated = 0
        binding.wrappedValue[1] = 2
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 10)
        #expect(newViewsCreated == 4)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Header 0")
            #expect(next() == "0 A")
            #expect(next() == "0 C")
            #expect(next() == "Footer 0")
            #expect(next() == "Header 2")
            #expect(next() == "2 A")
            #expect(next() == "2 C")
            #expect(next() == "Footer 2")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Inserting D")
        newViewsCreated = 0
        nestedBinding.wrappedValue.insert("D", at: 1)
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 12)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Header 0")
            #expect(next() == "0 A")
            #expect(next() == "0 D")
            #expect(next() == "0 C")
            #expect(next() == "Footer 0")
            #expect(next() == "Header 2")
            #expect(next() == "2 A")
            #expect(next() == "2 D")
            #expect(next() == "2 C")
            #expect(next() == "Footer 2")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Remove A D C")
        newViewsCreated = 0
        nestedBinding.wrappedValue.removeAll()
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Header 0")
            #expect(next() == "Footer 0")
            #expect(next() == "Header 2")
            #expect(next() == "Footer 2")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Add B A")
        newViewsCreated = 0
        nestedBinding.wrappedValue = ["B", "A"]
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 10)
        #expect(newViewsCreated == 4)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Header 0")
            #expect(next() == "0 B")
            #expect(next() == "0 A")
            #expect(next() == "Footer 0")
            #expect(next() == "Header 2")
            #expect(next() == "2 B")
            #expect(next() == "2 A")
            #expect(next() == "Footer 2")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Remove 0 2")
        newViewsCreated = 0
        binding.wrappedValue.removeAll()
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        print("\n🔧 Add 1 0")
        newViewsCreated = 0
        binding.wrappedValue = [1, 0]
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 10)
        #expect(newViewsCreated == 8)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "Header")
            #expect(next() == "Header 1")
            #expect(next() == "1 B")
            #expect(next() == "1 A")
            #expect(next() == "Footer 1")
            #expect(next() == "Header 0")
            #expect(next() == "0 B")
            #expect(next() == "0 A")
            #expect(next() == "Footer 0")
            #expect(next() == "Footer")
            #expect(rest() == [])
        }
        
        rootView = nil
        await #expect(dynamicChecker.getNotDeallocated().count == 0)
    }
    
    @Test func testNForEachReplacingOnlyNested() async {
        let nestedState: NState<[String]> = .init(wrappedValue: ["A"])
        let nestedBinding: NBinding<[String]> = nestedState.projectedValue
        
        var rootView: NHStack! = NHStack {
            NForEach([0, 1]) { (outer: Int) in
                NForEach(nestedBinding) { (inner: NGet<String>) in
                    self.createText("\(outer) \(inner.wrappedValue)")
                }
                .checkDealloc(in: dynamicChecker)
            }
            .checkDealloc(in: dynamicChecker)
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "1 A")
            #expect(rest() == [])
        }
        
        print("\n🔧 Appending B")
        newViewsCreated = 0
        nestedBinding.wrappedValue.append("B")
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(next() == "1 A")
            #expect(next() == "1 B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with C")
        newViewsCreated = 0
        nestedBinding.wrappedValue[1] = "C"
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 C")
            #expect(next() == "1 A")
            #expect(next() == "1 C")
            #expect(rest() == [])
        }
        
        print("\n🔧 Inserting D")
        newViewsCreated = 0
        nestedBinding.wrappedValue.insert("D", at: 1)
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 D")
            #expect(next() == "0 C")
            #expect(next() == "1 A")
            #expect(next() == "1 D")
            #expect(next() == "1 C")
            #expect(rest() == [])
        }
        
        print("\n🔧 Remove A D C")
        newViewsCreated = 0
        nestedBinding.wrappedValue.removeAll()
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        print("\n🔧 Add B A")
        newViewsCreated = 0
        nestedBinding.wrappedValue = ["B", "A"]
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 4)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "0 B")
            #expect(next() == "0 A")
            #expect(next() == "1 B")
            #expect(next() == "1 A")
            #expect(rest() == [])
        }
        
        rootView = nil
        await #expect(dynamicChecker.getNotDeallocated().count == 0)
    }
    
    @Test func testNForEachReplacingOnlyOuter() async {
        let state: NState<[Int]> = .init(wrappedValue: [0])
        let binding: NBinding<[Int]> = state.projectedValue
        
        var rootView: NHStack! = NHStack {
            NForEach(binding) { (outer: NGet<Int>) in
                NForEach(["A", "B"]) { (inner: String) in
                    self.createText("\(outer.wrappedValue) \(inner)")
                }
                .checkDealloc(in: dynamicChecker)
            }
            .checkDealloc(in: dynamicChecker)
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 2)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Appending 1")
        newViewsCreated = 0
        binding.wrappedValue.append(1)
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(next() == "1 A")
            #expect(next() == "1 B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing 1 with 2")
        newViewsCreated = 0
        binding.wrappedValue[1] = 2
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(next() == "2 A")
            #expect(next() == "2 B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Inserting 3")
        newViewsCreated = 0
        binding.wrappedValue.insert(3, at: 1)
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 4)
        rootView.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(next() == "3 A")
            #expect(next() == "3 B")
            #expect(next() == "2 A")
            #expect(next() == "2 B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Remove 0 3 2")
        newViewsCreated = 0
        binding.wrappedValue.removeAll()
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 0)
        #expect(newViewsCreated == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(rest() == [])
        }
        
        print("\n🔧 Add 1 0")
        newViewsCreated = 0
        binding.wrappedValue = [1, 0]
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 4)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        rootView.check { next, rest in
            #expect(next() == "1 A")
            #expect(next() == "1 B")
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(rest() == [])
        }
        
        rootView = nil
        await #expect(dynamicChecker.getNotDeallocated().count == 0)
    }
    
    @Test func testNForEachReplacingWithBindedTexts() async {
        let state: NState<[String]> = .init(wrappedValue: ["A", "B"])
        let binding: NBinding<[String]> = state.projectedValue
        
        var rootView: NHStack! = NHStack {
            NForEach(binding) { (inner: NGet<String>) in
                self.createText(inner.wrappedValue)
            }
            .checkDealloc(in: dynamicChecker)
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Appending C")
        newViewsCreated = 0
        binding.wrappedValue.append("C")
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 3)
        #expect(newViewsCreated == 1)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "B")
            #expect(next() == "C")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with D")
        newViewsCreated = 0
        binding.wrappedValue[1] = "D"
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 3)
        #expect(newViewsCreated == 1)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "D")
            #expect(next() == "C")
            #expect(rest() == [])
        }
        
        rootView = nil
        await #expect(dynamicChecker.getNotDeallocated().count == 0)
    }
    
    @Test func testNForEachReplacingWithBindedTextsInFixedArray() async {
        let state: NState<FixedArray3<String>> = .init(wrappedValue: .init("A", "B", "C"))
        let binding: NBinding<FixedArray3<String>> = state.projectedValue
        
        var rootView: NHStack! = NHStack {
            NForEach(constantSize: binding) { (inner: NGet<String>) in
                self.createText(inner)
            }
            .checkDealloc(in: dynamicChecker)
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 3)
        #expect(newViewsCreated == 3)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "B")
            #expect(next() == "C")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with D")
        newViewsCreated = 0
        binding.wrappedValue[1] = "D"
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 3)
        #expect(newViewsCreated == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "D")
            #expect(next() == "C")
            #expect(rest() == [])
        }
        
        rootView = nil
        await #expect(dynamicChecker.getNotDeallocated().count == 0)
    }
    
    #if swift(>=6.2)
    @available(macOS 26.0, iOS 26.0, *)
    @Test func testNForEachReplacingWithBindedTextsInInlineArray() async {
        let state: NState<InlineArray<_, String>> = .init(wrappedValue: ["A", "B", "C"])
        let binding: NBinding<InlineArray<_, String>> = state.projectedValue
        
        var rootView: NHStack! = NHStack {
            NForEach(binding) { (inner: NGet<String>) in
                self.createText(inner)
            }
            .checkDealloc(in: dynamicChecker)
        }
        
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 3)
        #expect(newViewsCreated == 3)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "B")
            #expect(next() == "C")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with D")
        newViewsCreated = 0
        binding.wrappedValue[1] = "D"
        rootView.printStack()
        #expect(rootView.stack.arrangedSubviews.count == 3)
        #expect(newViewsCreated == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getNotDeallocated().count == 1)
        rootView.check { next, rest in
            #expect(next() == "A")
            #expect(next() == "D")
            #expect(next() == "C")
            #expect(rest() == [])
        }
        
        rootView = nil
        await #expect(dynamicChecker.getNotDeallocated().count == 0)
    }
    #endif
}
