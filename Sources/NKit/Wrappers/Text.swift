import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension Text {
    public convenience init(
        _ text: NSAttributedString,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self.init(
            NGet.constant(text),
            alignment: alignment,
            multiline: multiline
        )
    }
    
    public convenience init(
        _ text: String,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self.init(
            NGet.constant(text),
            alignment: alignment,
            multiline: multiline
        )
    }
    
    public convenience init(
        _ textBinding: NBinding<NSAttributedString>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self.init(
            textBinding.get,
            alignment: alignment,
            multiline: multiline
        )
    }
    
    public convenience init(
        _ textBinding: NBinding<String>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self.init(
            textBinding.get.map(up: {
                NSAttributedString(string: $0)
            }),
            alignment: alignment,
            multiline: multiline
        )
    }
    
    public convenience init(
        _ textBinding: NGet<String>,
        alignment: NSTextAlignment = .left,
        multiline: Bool = true
    ) {
        self.init(
            textBinding.map(up: {
                NSAttributedString(string: $0)
            }),
            alignment: alignment,
            multiline: multiline
        )
    }
}
