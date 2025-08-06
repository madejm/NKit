import Testing
@testable import NKit

@Suite("ViewTests")
@MainActor
struct ViewTests {
    @Test func testExample() {
        _ = NHStack {
            sampleView()
            sampleBuilder()
            
            NVStack {
                sampleView()
            }
            NVStack {
                sampleBuilder()
            }
            NHStack {
                sampleView()
            }
            NHStack {
                sampleBuilder()
            }
        }
    }
    
    @MainActor
    private func sampleView() -> _View {
        Text("Test")
    }
    
    @MainActor
    @NViewBuilder
    private func sampleBuilder() -> [NView] {
        Text("Test")
    }
}
