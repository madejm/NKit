import Testing
import SwiftUI
@testable import NKit

@Suite("DeallocationTests")
@MainActor
struct DeallocationTests {
    nonisolated(unsafe) let viewChecker = DeallocationChecker()
    nonisolated(unsafe) let dynamicChecker = DeallocationChecker()
    @NValue var newViewsCreated: Int = 0
    
    init() {
    }
    
    func createText(_ string: String) -> NText {
        let text = NText(string)
        newViewsCreated += 1
        self.viewChecker.append(text)
        return text
    }
    
    @Test func test1() async {
        @NState var array: [Int] = [0]
        @NState var boolean1: Bool = true
        @NState var boolean2: Bool = true
        @NState var boolean3: Bool = true
        
        var rootView: NHStack! = NHStack {
            NIf($boolean1) {
                NForEach($array) { index in
                    NIf($boolean2) {
                        self.createText("\(index.wrappedValue) A")
                    } else: {
                        self.createText("\(index.wrappedValue) B")
                        self.createText("\(index.wrappedValue) C")
                    }
                    .checkDealloc(in: dynamicChecker)
                }
                .checkDealloc(in: dynamicChecker)
            } else: {
                NForEach($array) { index in
                    NIf($boolean3) {
                        self.createText("\(index.wrappedValue) D")
                        self.createText("\(index.wrappedValue) E")
                        self.createText("\(index.wrappedValue) F")
                        self.createText("\(index.wrappedValue) G")
                    } else: {
                        self.createText("\(index.wrappedValue) H")
                        self.createText("\(index.wrappedValue) I")
                        self.createText("\(index.wrappedValue) J")
                        self.createText("\(index.wrappedValue) K")
                        self.createText("\(index.wrappedValue) L")
                        self.createText("\(index.wrappedValue) M")
                        self.createText("\(index.wrappedValue) N")
                        self.createText("\(index.wrappedValue) O")
                    }
                    .checkDealloc(in: dynamicChecker)
                }
                .checkDealloc(in: dynamicChecker)
            }
            .checkDealloc(in: dynamicChecker)
        }
        
        #expect(rootView.stack.arrangedSubviews.count == 1)
        print(rootView.stack.arrangedSubviews)
        #expect(newViewsCreated == 1)
        await #expect(viewChecker.getDeallocatedCount() == 0)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getDeallocatedCount() == 0)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        
        viewChecker.cleanup()
        dynamicChecker.cleanup()
        newViewsCreated = 0
        boolean2 = false
        
        #expect(rootView.stack.arrangedSubviews.count == 2)
        print(rootView.stack.arrangedSubviews)
        #expect(newViewsCreated == 2)
        await #expect(viewChecker.getDeallocatedCount() == 1)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getDeallocatedCount() == 0)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        
        viewChecker.cleanup()
        dynamicChecker.cleanup()
        newViewsCreated = 0
        boolean1 = false
        
        #expect(rootView.stack.arrangedSubviews.count == 4)
        print(rootView.stack.arrangedSubviews)
        #expect(newViewsCreated == 4)
        await #expect(viewChecker.getDeallocatedCount() == 2)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getDeallocatedCount() == 2)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        
        viewChecker.cleanup()
        dynamicChecker.cleanup()
        newViewsCreated = 0
        boolean3 = false
        
        #expect(rootView.stack.arrangedSubviews.count == 8)
        print(rootView.stack.arrangedSubviews)
        #expect(newViewsCreated == 8)
        await #expect(viewChecker.getDeallocatedCount() == 4)
        await #expect(viewChecker.getNotDeallocated().count == rootView.stack.arrangedSubviews.count)
        await #expect(dynamicChecker.getDeallocatedCount() == 0)
        await #expect(dynamicChecker.getNotDeallocated().count == 3)
        
        viewChecker.cleanup()
        dynamicChecker.cleanup()
        rootView = nil
        
        await #expect(viewChecker.getDeallocatedCount() == 8)
        await #expect(viewChecker.getNotDeallocated().count == 0)
        await #expect(dynamicChecker.getDeallocatedCount() == 3)
        await #expect(dynamicChecker.getNotDeallocated().count == 0)
    }
}
