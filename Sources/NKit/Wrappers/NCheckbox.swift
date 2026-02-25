import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NCheckbox {

    public convenience init(
        title: String,
        state stateBinding: NBinding<Bool>
    ) {
        self.init(
            title: NGet.constant(title),
            state: stateBinding
        )
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState var isOn: Bool = false
    
    var title: NGet<String> = $isOn.get.map {
        $0 ? "On" : "Off"
    }
    
    NViewPreview {
        NVStack(spacing: 8) {
            NCheckbox(title: title, state: $isOn)
                .background(.red)
            NCheckbox(title: title, state: $isOn)
                .background(.red)
        }
        .padding(20)
    }
}
#endif
