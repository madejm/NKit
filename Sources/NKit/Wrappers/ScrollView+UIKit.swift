import Foundation
#if canImport(UIKit)
import UIKit

open class ScrollView: UIScrollView {
    public enum Direction {
        case vertical
        case horizontal
        case twoDimmensions
    }
    
    public init(
        _ direction: Direction = .vertical,
        _ content: UIView
    ) {
        super.init(frame: .zero)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
        
        NSLayoutConstraint.activate([
            self.contentLayoutGuide.topAnchor.constraint(equalTo: content.topAnchor),
            self.contentLayoutGuide.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            self.contentLayoutGuide.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            self.contentLayoutGuide.trailingAnchor.constraint(equalTo: content.trailingAnchor),
        ])
        
        if case .vertical = direction {
            NSLayoutConstraint.activate([
                self.frameLayoutGuide.leadingAnchor.constraint(equalTo: content.leadingAnchor),
                self.frameLayoutGuide.trailingAnchor.constraint(equalTo: content.trailingAnchor)
            ])
        }
        
        if case .horizontal = direction {
            NSLayoutConstraint.activate([
                self.frameLayoutGuide.topAnchor.constraint(equalTo: content.topAnchor),
                self.frameLayoutGuide.bottomAnchor.constraint(equalTo: content.bottomAnchor)
            ])
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
