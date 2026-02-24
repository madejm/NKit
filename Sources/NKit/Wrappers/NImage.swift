import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NImage {
    public convenience init(_ image: _Image) {
        self.init(NGet.constant(image))
    }
    
    public convenience init(_ imageBinding: NBinding<_Image?>) {
        self.init(imageBinding.get)
    }
    
    public convenience init(_ imageBinding: NBinding<_Image>) {
        self.init(imageBinding.get.map())
    }
}

extension _Image: NView {
    public var body: _View {
        NImage(self)
    }
}

extension _Image {
    @available(macOS 11.0, iOS 13.0, *)
    public convenience init?(systemName: String) {
        #if canImport(AppKit)
        self.init(
            systemSymbolName: systemName,
            accessibilityDescription: ""
        )
        #elseif canImport(UIKit)
        self.init(
            systemName: systemName,
            withConfiguration: nil
        )
        #endif
    }
}

#if DEBUG
@available(macOS 11.0, iOS 13.0, *)
#Preview {
    NViewPreview {
        NVStack(alignment: .center, spacing: 8) {
            NHStack(alignment: .center, spacing: 8) {
                _Image(systemName: "car")!
                _Image(systemName: "airplane")!
                _Image(systemName: "bus")!
                _Image(systemName: "ferry")!
                _Image(systemName: "tram")!
            }
            NHStack(alignment: .center, spacing: 8) {
                NImage(_Image(systemName: "car")!)
                NImage(_Image(systemName: "airplane")!)
                NImage(_Image(systemName: "bus")!)
                NImage(_Image(systemName: "ferry")!)
                NImage(_Image(systemName: "tram")!)
            }
        }
    }
}
#endif
