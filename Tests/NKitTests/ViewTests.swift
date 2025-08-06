import Testing
import AppKit
@testable import NKit

@Suite("ViewTests")
@MainActor
struct ViewTests {
    @Test func testStacks() {
        let rootView = NHStack {
            sampleView()
            sampleBuilder()
            
            NVStack {
                sampleView()
                sampleBuilder()
            }
        }
        
        #expect(rootView.stack.subviews.count == 4)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "Text 1")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "Text 2")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "Text 3")
        
        #expect(rootView.stack.subviews[3].asStack?.subviews.count == 3)
        #expect(rootView.stack.subviews[3].asStack?.subviews[0].asText?.stringValue == "Text 1")
        #expect(rootView.stack.subviews[3].asStack?.subviews[1].asText?.stringValue == "Text 2")
        #expect(rootView.stack.subviews[3].asStack?.subviews[2].asText?.stringValue == "Text 3")
    }
    
    @Test func testNForEachConstant() {
        let rootView = NHStack {
            NVStack {
                let array: [Int] = [1, 2]
                
                NForEach(array) { index in
                    sampleView(String(index))
                    sampleBuilder(String(index))
                }
            }
            
            NHStack {
                let dictionary: [String: [String]] = ["A": ["1"], "B": ["2", "3"]]
                
                NForEach(dictionary) { key, array in
                    NForEach(array) { value in
                        sampleView(key + value)
                        sampleBuilder(key + value)
                    }
                }
            }
        }
        
        #expect(rootView.stack.subviews.count == 2)
        
        #expect(rootView.stack.subviews[0].asStack?.subviews.count == 6)
        #expect(rootView.stack.subviews[0].asStack?.subviews[0].asText?.stringValue == "Text 1_1")
        #expect(rootView.stack.subviews[0].asStack?.subviews[1].asText?.stringValue == "Text 2_1")
        #expect(rootView.stack.subviews[0].asStack?.subviews[2].asText?.stringValue == "Text 3_1")
        #expect(rootView.stack.subviews[0].asStack?.subviews[3].asText?.stringValue == "Text 1_2")
        #expect(rootView.stack.subviews[0].asStack?.subviews[4].asText?.stringValue == "Text 2_2")
        #expect(rootView.stack.subviews[0].asStack?.subviews[5].asText?.stringValue == "Text 3_2")
        
        #expect(rootView.stack.subviews[1].asStack?.subviews.count == 9)
        #expect(rootView.stack.subviews[1].asStack?.subviews[0].asText?.stringValue == "Text 1_A1")
        #expect(rootView.stack.subviews[1].asStack?.subviews[1].asText?.stringValue == "Text 2_A1")
        #expect(rootView.stack.subviews[1].asStack?.subviews[2].asText?.stringValue == "Text 3_A1")
        #expect(rootView.stack.subviews[1].asStack?.subviews[3].asText?.stringValue == "Text 1_B2")
        #expect(rootView.stack.subviews[1].asStack?.subviews[4].asText?.stringValue == "Text 2_B2")
        #expect(rootView.stack.subviews[1].asStack?.subviews[5].asText?.stringValue == "Text 3_B2")
        #expect(rootView.stack.subviews[1].asStack?.subviews[6].asText?.stringValue == "Text 1_B3")
        #expect(rootView.stack.subviews[1].asStack?.subviews[7].asText?.stringValue == "Text 2_B3")
        #expect(rootView.stack.subviews[1].asStack?.subviews[8].asText?.stringValue == "Text 3_B3")
    }
    
    @Test func testNForEachGet() {
        let state: NState<[String]> = .init(wrappedValue: ["1", "2"])
        let get: NGet<[String]> = state.projectedValue.get
        
        let rootView = NHStack {
            NForEach(get) { index in
                sampleView(index.wrappedValue)
                sampleBuilder(index.wrappedValue)
            }
        }
        
        #expect(rootView.stack.subviews.count == 6)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "Text 1_1")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "Text 2_1")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "Text 3_1")
        #expect(rootView.stack.subviews[3].asText?.stringValue == "Text 1_2")
        #expect(rootView.stack.subviews[4].asText?.stringValue == "Text 2_2")
        #expect(rootView.stack.subviews[5].asText?.stringValue == "Text 3_2")
    }
    
    @Test func testNForEachBinding() {
        let state: NState<[String]> = .init(wrappedValue: ["1", "2"])
        let binding: NBinding<[String]> = state.projectedValue
        
        let rootView = NHStack {
            NForEach(binding) { index in
                sampleView(index.wrappedValue)
                sampleBuilder(index.wrappedValue)
            }
        }
        
        #expect(rootView.stack.subviews.count == 6)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "Text 1_1")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "Text 2_1")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "Text 3_1")
        #expect(rootView.stack.subviews[3].asText?.stringValue == "Text 1_2")
        #expect(rootView.stack.subviews[4].asText?.stringValue == "Text 2_2")
        #expect(rootView.stack.subviews[5].asText?.stringValue == "Text 3_2")
        
        state.wrappedValue += ["3"]
        
        #expect(rootView.stack.subviews.count == 9)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "Text 1_1")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "Text 2_1")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "Text 3_1")
        #expect(rootView.stack.subviews[3].asText?.stringValue == "Text 1_2")
        #expect(rootView.stack.subviews[4].asText?.stringValue == "Text 2_2")
        #expect(rootView.stack.subviews[5].asText?.stringValue == "Text 3_2")
        #expect(rootView.stack.subviews[6].asText?.stringValue == "Text 1_3")
        #expect(rootView.stack.subviews[7].asText?.stringValue == "Text 2_3")
        #expect(rootView.stack.subviews[8].asText?.stringValue == "Text 3_3")
        
        state.wrappedValue = ["4"]
        
        #expect(rootView.stack.subviews.count == 3)
        #expect(rootView.stack.subviews[0].asText?.stringValue == "Text 1_4")
        #expect(rootView.stack.subviews[1].asText?.stringValue == "Text 2_4")
        #expect(rootView.stack.subviews[2].asText?.stringValue == "Text 3_4")
    }
    
    private func sampleView(_ postfix: String? = nil) -> NView {
        text(index: "1", postfix: postfix)
    }
    
    @NViewBuilder
    private func sampleBuilder(_ postfix: String? = nil) -> [NView] {
        text(index: "2", postfix: postfix)
        text(index: "3", postfix: postfix)
    }
    
    private func text(index: String, postfix: String?) -> NView {
        Text("Text \(index)" + (postfix.map({ "_\($0)" }) ?? ""))
    }
}

extension NSView {
    fileprivate var asText: NSTextField? {
        #expect(self is NSTextField)
        return self as? NSTextField
    }
    
    fileprivate var asStack: NSStackView? {
        #expect(self is ViewStack)
        let viewStack = self as? ViewStack
        return viewStack?.stack
    }
}
