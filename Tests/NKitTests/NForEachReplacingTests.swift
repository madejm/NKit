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
        
        #expect(rootView.stack.subviews.count == 4)
        #expect(newViewsCreated == 4)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "0")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "1")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "2")
        #expect(rootView.stack.subviews[3].asText?.stringValue == "0")
        
        newViewsCreated = 0
        binding[1].wrappedValue = 3
        #expect(rootView.stack.subviews.count == 4)
        #expect(newViewsCreated == 1)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "0")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "3")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "2")
        #expect(rootView.stack.subviews[3].asText?.stringValue == "0")
        
        newViewsCreated = 0
        binding.wrappedValue.swapAt(1, 2)
        #expect(rootView.stack.subviews.count == 4)
        #expect(newViewsCreated == 0)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "0")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "2")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "3")
        #expect(rootView.stack.subviews[3].asText?.stringValue == "0")
        
        newViewsCreated = 0
        binding.wrappedValue.insert(0, at: 1)
        #expect(rootView.stack.subviews.count == 5)
        #expect(newViewsCreated == 1)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "0")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "0")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "2")
        #expect(rootView.stack.subviews[3].asText?.stringValue == "3")
        #expect(rootView.stack.subviews[4].asText?.stringValue == "0")
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
        #expect(rootView.stack.subviews.count == 2)
        #expect(newViewsCreated == 2)
        #expect(rootView.stack.arrangedSubviews[0].asText?.stringValue == "0 A")
        #expect(rootView.stack.arrangedSubviews[1].asText?.stringValue == "1 A")
        
        print("\n🔧 Appending B")
        newViewsCreated = 0
        nestedBinding.wrappedValue.append("B")
        printStack()
        #expect(rootView.stack.subviews.count == 4)
        #expect(newViewsCreated == 2)
        #expect(rootView.stack.arrangedSubviews[0].asText?.stringValue == "0 A")
        #expect(rootView.stack.arrangedSubviews[1].asText?.stringValue == "0 B")
        #expect(rootView.stack.arrangedSubviews[2].asText?.stringValue == "1 A")
        #expect(rootView.stack.arrangedSubviews[3].asText?.stringValue == "1 B")
        
        print("\n🔧 Replacing B with C")
        newViewsCreated = 0
        nestedBinding[1].wrappedValue = "C"
        printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        #expect(rootView.stack.arrangedSubviews[0].asText?.stringValue == "0 A")
        #expect(rootView.stack.arrangedSubviews[1].asText?.stringValue == "0 C")
        #expect(rootView.stack.arrangedSubviews[2].asText?.stringValue == "1 A")
        #expect(rootView.stack.arrangedSubviews[3].asText?.stringValue == "1 C")
        
        print("\n🔧 Replacing 1 with 2")
        newViewsCreated = 0
        binding[1].wrappedValue = 2
        printStack()
        #expect(rootView.stack.arrangedSubviews.count == 4)
        #expect(newViewsCreated == 2)
        #expect(rootView.stack.arrangedSubviews[0].asText?.stringValue == "0 A")
        #expect(rootView.stack.arrangedSubviews[1].asText?.stringValue == "0 C")
        #expect(rootView.stack.arrangedSubviews[2].asText?.stringValue == "2 A")
        #expect(rootView.stack.arrangedSubviews[3].asText?.stringValue == "2 C")
        
        print("🔧 Inserting D")
        newViewsCreated = 0
        nestedBinding.wrappedValue.insert("D", at: 1)
        printStack()
        #expect(rootView.stack.arrangedSubviews.count == 6)
        #expect(newViewsCreated == 2)
        #expect(rootView.stack.arrangedSubviews[0].asText?.stringValue == "0 A")
        #expect(rootView.stack.arrangedSubviews[1].asText?.stringValue == "0 D")
        #expect(rootView.stack.arrangedSubviews[2].asText?.stringValue == "0 C")
        #expect(rootView.stack.arrangedSubviews[3].asText?.stringValue == "2 A")
        #expect(rootView.stack.arrangedSubviews[4].asText?.stringValue == "2 D")
        #expect(rootView.stack.arrangedSubviews[5].asText?.stringValue == "2 C")
    }
}
