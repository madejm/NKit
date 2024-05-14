import Foundation
#if canImport(AppKit)
import AppKit

open class ScrollView: NSScrollView {
    public init(
        _ content: NSView
    ) {
        super.init(frame: .zero)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        self.documentView = content
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: content.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            content.heightAnchor.constraint(greaterThanOrEqualTo: self.contentView.heightAnchor),
            content.widthAnchor.constraint(greaterThanOrEqualTo: self.contentView.widthAnchor)
        ])
        
        self.scrollerStyle = .overlay
        self.hasHorizontalScroller = true
        self.hasVerticalScroller = true
        self.autohidesScrollers = true
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
