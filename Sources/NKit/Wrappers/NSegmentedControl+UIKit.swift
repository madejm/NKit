import Foundation
#if canImport(UIKit)
import UIKit

open class NSegmentedControl<C>: UISegmentedControl
where C: Equatable, C: RandomAccessCollection, C.Index == Int, C.Element: Equatable {
    
    @NBinding private var selection: Int
    @NGet private var values: C
    
    private init(
        selection: NBinding<Int>,
        values: NGet<C>,
        insert: @escaping (UISegmentedControl, C.Element, Int) -> Void,
        set: @escaping (UISegmentedControl, C.Element, Int) -> Void
    ) {
        self._selection = selection
        self._values = values
        
        super.init(frame: .zero)
        
        self.addTarget(self, action: #selector(touchAction), for: .valueChanged)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        for value in values.wrappedValue.enumerated() {
            insert(self, value.element, value.offset)
        }
        self.selectedSegmentIndex = selection.wrappedValue
        
        self._values.onChange { [weak self] values in
            guard let self else {
                return
            }
            let values: C = self.values
            for value in values.enumerated() {
                if value.offset < self.numberOfSegments {
                    set(self, value.element, value.offset)
                } else {
                    insert(self, value.element, value.offset)
                }
            }
            if values.count < self.numberOfSegments {
                for _ in values.count..<self.numberOfSegments {
                    self.removeSegment(at: values.count, animated: true)
                }
            }
            
            if self.selectedSegmentIndex < self.numberOfSegments, self.selectedSegmentIndex >= 0 {
                self.selection = self.selection
            } else {
                self.selection = 0
            }
        }
        
        self._selection.onChange { [weak self] selectedIndex in
            self?.selectedSegmentIndex = selectedIndex
        }
    }
    
    public convenience init(
        selection: NBinding<Int>,
        images: NGet<C>
    ) where C.Element == _Image {
        self.init(
            selection: selection,
            values: images,
            insert: { this, image, index in
                this.insertSegment(with: image, at: index, animated: true)
            },
            set: { this, image, index in
                this.setImage(image, forSegmentAt: index)
            }
        )
    }
    
    public convenience init(
        selection: NBinding<Int>,
        labels: NGet<C>
    ) where C.Element == String {
        self.init(
            selection: selection,
            values: labels,
            insert: { this, label, index in
                this.insertSegment(withTitle: label, at: index, animated: true)
            },
            set: { this, label, index in
                this.setTitle(label, forSegmentAt: index)
            }
        )
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchAction() {
        selection = self.selectedSegmentIndex
    }
}
#endif
