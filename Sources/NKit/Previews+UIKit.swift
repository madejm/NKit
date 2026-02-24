import Foundation
#if canImport(SwiftUI) && canImport(UIKit) && DEBUG
import SwiftUI
import UIKit

public struct NViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    private let viewController: ViewController

    public init(_ builder: @escaping @MainActor () -> ViewController) {
        viewController = builder()
    }
    
    // MARK: - UIViewControllerRepresentable
    public func makeUIViewController(context: Context) -> ViewController {
        viewController
    }
    
    public func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

public struct NViewPreview<View: UIView>: UIViewRepresentable {
    private let view: View
    
    public init(_ builder: @escaping @MainActor () -> View) {
        view = builder()
    }
    
    // MARK: - UIViewRepresentable
    public func makeUIView(context: Context) -> UIView {
        return view
    }
    
    public func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif
