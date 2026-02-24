import Foundation
#if canImport(SwiftUI) && canImport(AppKit) && DEBUG
import SwiftUI
import AppKit

public struct NViewControllerPreview<ViewController: NSViewController>: NSViewControllerRepresentable {
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

public struct NViewPreview: NSViewRepresentable {
    private let view: NSView
    
    public init<View: NSView>(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    public init<View: NView>(_ builder: @escaping () -> View) {
        view = builder().body
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

public struct NStoryboardPreview: NSViewControllerRepresentable {
    private let viewController: NSViewController?
    
    public init(
        storyboard storyboardName: String,
        window windowIdentifier: String,
        bundle storyboardBundleOrNil: Bundle? = nil
    ) {
        let storyboard = NSStoryboard(
            name: NSStoryboard.Name(storyboardName),
            bundle: storyboardBundleOrNil
        )
        let controler: Any = storyboard.instantiateController(
            withIdentifier: NSStoryboard.SceneIdentifier(windowIdentifier)
        )
        self.viewController = (controler as? NSWindowController)?.contentViewController
    }
    
    public init(
        storyboard storyboardName: String,
        viewController viewControllerIdentifier: String,
        bundle storyboardBundleOrNil: Bundle? = nil
    ) {
        let storyboard = NSStoryboard(
            name: NSStoryboard.Name(storyboardName),
            bundle: storyboardBundleOrNil
        )
        let controler: Any = storyboard.instantiateController(
            withIdentifier: NSStoryboard.SceneIdentifier(viewControllerIdentifier)
        )
        self.viewController = controler as? NSViewController
    }
    
    // MARK: - NSViewControllerRepresentable
    public func makeNSViewController(context: Context) -> NSViewController {
        viewController ?? NSViewController()
    }
    
    public func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
    }
}
#endif
