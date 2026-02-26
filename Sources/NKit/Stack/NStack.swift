import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public class NVStack: NViewStack {
    public init(
        alignment: Alignment = .center,
        spacing: CGFloat = 8,
        stretching: Stretching = .none,
        @NViewBuilder _ content: @escaping () -> [NView]
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

public class NHStack: NViewStack {
    public init(
        alignment: Alignment = .center,
        spacing: CGFloat = 8,
        stretching: Stretching = .none,
        @NViewBuilder _ content: @escaping () -> [NView]
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
