import Foundation
import CoreGraphics

@MainActor
public func NGeometryReader<Content: _View>(
    _ content: @escaping (_ size: NGet<CGSize>) -> Content
) -> Content {
    let state: NState<CGSize> = .init(wrappedValue: .zero)
    let get: NGet<CGSize> = state.get
    
    let readyContent: Content = content(get)
    
    readyContent
        .publisher(for: \.frame)
        .map(\.size)
        .removeDuplicates()
        .sink { size in
            state.wrappedValue = size
        }
        .store(in: &readyContent.cancellables)
    
    return readyContent
}
