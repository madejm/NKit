import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NSwitch {
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState<Bool> var isOn = false
    
    NViewPreview {
        NVStack(alignment: .center, spacing: 8) {
            NSwitch($isOn)
                .background(.red)
            NSwitch($isOn)
                .background(.red)
        }
        .frame(width: 300)
        .padding(8)
    }
}
#endif
