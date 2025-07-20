import Foundation
#if canImport(AppKit)
import AppKit

open class ScrollView: NSScrollView {
    public struct Axis: OptionSet {
        nonisolated(unsafe) public static let horizontal = Axis(rawValue: 1 << 0)
        nonisolated(unsafe) public static let vertical = Axis(rawValue: 1 << 1)
        nonisolated(unsafe) public static let both: Axis = [.horizontal, .vertical]
        
        public let rawValue: Int8
        
        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }
    }
    
    public init(
        axes: Axis = .both,
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
        self.hasHorizontalScroller = axes.contains(.horizontal)
        self.hasVerticalScroller = axes.contains(.vertical)
        self.autohidesScrollers = true
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
