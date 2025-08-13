import Testing
import AppKit
import SwiftUI
@testable import NKit

@Suite("NForEachReplacingTests")
@MainActor
struct NForEachReplacingTests {
    @Test func testNForEachReplacing() {
        let state: NState<[Int]> = .init(wrappedValue: [0, 1, 2, 0])
        let binding: NBinding<[Int]> = state.projectedValue
        
        var newViewsCreated: Int = 0
        
        let rootView = NHStack {
            NForEach(binding) { (index: NGet<Int?>) in
                if let value = index.wrappedValue {{
                    newViewsCreated += 1
                    return Text("\(value)")
                }()}
            }
        }
        
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 4)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "1")
            #expect(next() == "2")
            #expect(next() == "0")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing 1 with 3")
        newViewsCreated = 0
        binding[1].wrappedValue = 3
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 1)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "3")
            #expect(next() == "2")
            #expect(next() == "0")
            #expect(rest() == [])
        }
        
        print("\n🔧 Swaping 2 and 3")
        newViewsCreated = 0
        binding.wrappedValue.swapAt(1, 2)
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 0)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "2")
            #expect(next() == "3")
            #expect(next() == "0")
            #expect(rest() == [])
        }
        
        print("\n🔧 Inserting 0")
        newViewsCreated = 0
        binding.wrappedValue.insert(0, at: 1)
        #expect(rootView.stack.arrangedSubviews.count == 5)
        #expect(newViewsCreated == 1)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0")
            #expect(next() == "0")
            #expect(next() == "2")
            #expect(next() == "3")
            #expect(next() == "0")
            #expect(rest() == [])
        }
    }
    
    @Test func testNForEachReplacingNested() {
        let state: NState<[Int]> = .init(wrappedValue: [0, 1])
        let binding: NBinding<[Int]> = state.projectedValue
        
        let nestedState: NState<[String]> = .init(wrappedValue: ["A"])
        let nestedBinding: NBinding<[String]> = nestedState.projectedValue
        
        var newViewsCreated: Int = 0
        
        let rootView = NHStack {
            NForEach(binding, DEBUG_LABEL: "OUTER") { (outer: NGet<Int?>) in
                NForEach(nestedBinding, DEBUG_LABEL: "INNER \(outer.wrappedValue.map { String($0) } ?? "?")") { (inner: NGet<String?>) in
                    if let value1 = outer.wrappedValue,
                       let value2 = inner.wrappedValue {
                        {
                            newViewsCreated += 1
                            let text = "\(value1) \(value2)"
                            print("✨ Creating view: \(text)")
                            return Text(text)
                        }()
                    }
                }
            }
        }
        
        func printStack() {
            print("")
            print("STACK:")
            
            for i in 0..<rootView.stack.arrangedSubviews.count {
                print("\(i): \(rootView.stack.arrangedSubviews[i].asText?.stringValue ?? "")")
            }
        }
        
        printStack()
        #expect(rootView.stack.arrangedSubviews.count == 2)
        #expect(newViewsCreated == 2)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "1 A")
            #expect(rest() == [])
        }
        
        print("\n🔧 Appending B")
        newViewsCreated = 0
        nestedBinding.wrappedValue.append("B")
        printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 B")
            #expect(next() == "1 A")
            #expect(next() == "1 B")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing B with C")
        newViewsCreated = 0
        nestedBinding[1].wrappedValue = "C"
        printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 C")
            #expect(next() == "1 A")
            #expect(next() == "1 C")
            #expect(rest() == [])
        }
        
        print("\n🔧 Replacing 1 with 2")
        newViewsCreated = 0
        binding[1].wrappedValue = 2
        printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 C")
            #expect(next() == "2 A")
            #expect(next() == "2 C")
            #expect(rest() == [])
        }
        
        print("🔧 Inserting D")
        newViewsCreated = 0
        nestedBinding.wrappedValue.insert("D", at: 1)
        printStack()
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 2)
        rootView.stack.arrangedSubviews.check { next, rest in
            #expect(next() == "0 A")
            #expect(next() == "0 D")
            #expect(next() == "0 C")
            #expect(next() == "2 A")
            #expect(next() == "2 D")
            #expect(next() == "2 C")
            #expect(rest() == [])
        }
    }
}

extension Array where Element: NSView {
    @MainActor
    func check(
        _ subviews: (
            _ next: () -> String?,
            _ rest: () -> [String?]
        ) -> Void
    ) {
        var copy = self
        
        subviews(
            {
                #expect(!copy.isEmpty)
                
                guard !copy.isEmpty else {
                    return nil
                }
                return copy.removeFirst().asText?.stringValue
            },
            {
                copy.map { $0.asText?.stringValue }
            }
        )
    }
}
