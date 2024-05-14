import Foundation
#if canImport(SwiftUI) && canImport(AppKit) && DEBUG
import SwiftUI
import AppKit

public struct NSViewControllerPreview<ViewController: NSViewController>: NSViewControllerRepresentable {
    private let viewController: ViewController

    public init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
    // MARK: - NSViewControllerRepresentable
    public func makeNSViewController(context: Context) -> ViewController {
        viewController
    }
    
    public func updateNSViewController(_ nsViewController: ViewController, context: Context) {
    }
}

public struct NSViewPreview<View: NSView>: NSViewRepresentable {
    private let view: View
    
    public init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: - NSViewRepresentable
    public func makeNSView(context: Context) -> NSView {
        return view
    }
    
    public func updateNSView(_ view: NSView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif
