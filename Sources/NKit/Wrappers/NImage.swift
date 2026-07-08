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
    public enum ImageContentMode {
        case fill
        case aspectFit
        case aspectFill
        case center
        case top
        case bottom
        case left
        case right
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        #if canImport(AppKit)
        internal var imageScaling: NSImageScaling {
            switch self {
            case .fill:        .scaleAxesIndependently
            case .aspectFit:   .scaleProportionallyUpOrDown
            case .aspectFill:  .scaleProportionallyUpOrDown
            case .center:      .scaleNone
            case .top:         .scaleNone
            case .bottom:      .scaleNone
            case .left:        .scaleNone
            case .right:       .scaleNone
            case .topLeft:     .scaleNone
            case .topRight:    .scaleNone
            case .bottomLeft:  .scaleNone
            case .bottomRight: .scaleNone
            }
        }
        
        internal var imageAlignment: NSImageAlignment {
            switch self {
            case .fill:        .alignCenter
            case .aspectFit:   .alignCenter
            case .aspectFill:  .alignCenter
            case .center:      .alignCenter
            case .top:         .alignTop
            case .bottom:      .alignBottom
            case .left:        .alignLeft
            case .right:       .alignRight
            case .topLeft:     .alignTopLeft
            case .topRight:    .alignTopRight
            case .bottomLeft:  .alignBottomLeft
            case .bottomRight: .alignRight
            }
        }
//        internal var contentsGravity: CALayerContentsGravity {
//            switch self {
//            case .fill:        .resize
//            case .aspectFit:   .resizeAspect
//            case .aspectFill:  .resizeAspectFill
//            case .center:      .center
//            case .top:         .top
//            case .bottom:      .bottom
//            case .left:        .left
//            case .right:       .right
//            case .topLeft:     .topLeft
//            case .topRight:    .topRight
//            case .bottomLeft:  .bottomLeft
//            case .bottomRight: .bottomRight
//            }
//        }
        #elseif canImport(UIKit)
        internal var contentMode: UIView.ContentMode {
            switch self {
            case .fill:        .scaleToFill
            case .aspectFit:   .scaleAspectFit
            case .aspectFill:  .scaleAspectFill
            case .center:      .center
            case .top:         .top
            case .bottom:      .bottom
            case .left:        .left
            case .right:       .right
            case .topLeft:     .topLeft
            case .topRight:    .topRight
            case .bottomLeft:  .bottomLeft
            case .bottomRight: .bottomRight
            }
        }
        #endif
    }
    
    public convenience init(
        _ image: _Image?,
        contentMode: ImageContentMode = .aspectFit
    ) {
        self.init(NGet.constant(image), contentMode: contentMode)
    }
    
    public convenience init(
        _ imageBinding: NBinding<_Image?>,
        contentMode: ImageContentMode = .aspectFit
    ) {
        self.init(imageBinding.get, contentMode: contentMode)
    }
    
    public convenience init(
        _ imageBinding: NBinding<_Image>,
        contentMode: ImageContentMode = .aspectFit
    ) {
        self.init(imageBinding.get.map(), contentMode: contentMode)
    }
}

extension _Image: NView {
    public var body: _View {
        NImage(self)
    }
}

extension _Image {
    @inline(__always)
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
    
    @inline(__always)
    @available(macOS 10.15, iOS 11.0, *)
    public convenience init?(named name: String, in bundle: Bundle) {
        #if canImport(AppKit)
        let resource: ImageResource = .init(name: name, bundle: bundle)
        self.init(resource: resource)
        #elseif canImport(UIKit)
        self.init(
            named: name,
            in: bundle,
            with: nil
        )
        #endif
    }
}

#if DEBUG
@available(macOS 11.0, iOS 13.0, *)
#Preview {
    NViewPreview {
        NVStack {
            NHStack {
                NImage(_Image(named: "lena", in: .module)!, contentMode: .fill)
                    .background(.red)
                NImage(_Image(named: "lena", in: .module)!, contentMode: .aspectFit)
                    .background(.red)
                NImage(_Image(named: "lena", in: .module)!, contentMode: .aspectFill)
                    .background(.red)
            }
            NHStack {
                NImage(_Image(named: "lena", in: .module)!, contentMode: .topLeft)
                    .background(.red)
                NImage(_Image(named: "lena", in: .module)!, contentMode: .top)
                    .background(.red)
                NImage(_Image(named: "lena", in: .module)!, contentMode: .topRight)
                    .background(.red)
            }
            NHStack {
                NImage(_Image(named: "lena", in: .module)!, contentMode: .left)
                    .background(.red)
                NImage(_Image(named: "lena", in: .module)!, contentMode: .center)
                    .background(.red)
                NImage(_Image(named: "lena", in: .module)!, contentMode: .right)
                    .background(.red)
            }
            NHStack {
                NImage(_Image(named: "lena", in: .module)!, contentMode: .bottomLeft)
                    .background(.red)
                NImage(_Image(named: "lena", in: .module)!, contentMode: .bottom)
                    .background(.red)
                NImage(_Image(named: "lena", in: .module)!, contentMode: .bottomRight)
                    .background(.red)
            }
        }
    }
}

@available(macOS 11.0, iOS 13.0, *)
#Preview {
    NViewPreview {
        NVStack {
            NHStack {
                _Image(systemName: "car")!
                _Image(systemName: "airplane")!
                _Image(systemName: "bus")!
                _Image(systemName: "ferry")!
                _Image(systemName: "tram")!
            }
            NHStack {
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
