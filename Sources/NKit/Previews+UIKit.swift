import Foundation
#if canImport(SwiftUI) && canImport(UIKit) && DEBUG
import SwiftUI
import UIKit

public struct NViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    private let viewController: ViewController

    public init(_ builder: @MainActor () -> ViewController) {
        viewController = builder()
    }
    
    // MARK: - UIViewControllerRepresentable
    public func makeUIViewController(context: Context) -> ViewController {
        viewController
    }
    
    public func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

private final class _RepresentableWrapperView: UIView {
    let hostedView: UIView
    
    init(hostedView: UIView) {
        self.hostedView = hostedView
        super.init(frame: .zero)
        self.addSubviewAutomatically(hostedView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        hostedView.intrinsicContentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hostedView.invalidateIntrinsicContentSize()
    }
}

public struct NViewPreview: UIViewRepresentable {
    private let view: UIView
    
    public init<View: UIView>(_ builder: @MainActor () -> View) {
        view = builder()
    }
    
    public init<View: NView>(_ builder: @MainActor () -> View) {
        view = builder().body
    }
    
    // MARK: - UIViewRepresentable
    public func makeUIView(context: Context) -> UIView {
        let wrapper = _RepresentableWrapperView(hostedView: view)

        wrapper.setContentHuggingPriority(.required, for: .horizontal)
        wrapper.setContentHuggingPriority(.required, for: .vertical)
        wrapper.setContentCompressionResistancePriority(.required, for: .horizontal)
        wrapper.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return wrapper
    }
    
    public func updateUIView(_ view: UIView, context: Context) {
    }
}
#endif
