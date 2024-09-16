import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public class NVStack: ViewStack {
    public init(
        alignment: Alignment = .leading,
        spacing: CGFloat = 0,
        stretching: Stretching = .none,
        @NViewBuilder _ content: @escaping ViewCreator
    ) {
        super.init(
            alignment: alignment.alignment,
            orientation: .vertical,
            spacing: spacing,
            stretching: stretching,
            content: content
        )
    }
}

public class NHStack: ViewStack {
    public init(
        alignment: Alignment = .center,
        spacing: CGFloat = 0,
        stretching: Stretching = .none,
        @NViewBuilder _ content: @escaping ViewCreator
    ) {
        super.init(
            alignment: alignment.alignment,
            orientation: .horizontal,
            spacing: spacing,
            stretching: stretching,
            content: content
        )
    }
}
