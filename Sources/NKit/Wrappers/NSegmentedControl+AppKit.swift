import Foundation
#if canImport(AppKit)
import AppKit

open class NSegmentedControl<C>: NSSegmentedControl
where C: Equatable, C: RandomAccessCollection, C.Index == Int, C.Element: Equatable {
    
    @NBinding private var selection: Int
    @NGet private var values: C
    
    private init(
        selection: NBinding<Int>,
        values: NGet<C>
    ) {
        self._selection = selection
        self._values = values
        
        super.init(frame: .zero)
        
        self.trackingMode = .selectOne
        self.target = self
        self.action = #selector(touchAction)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        self.segmentCount = values.wrappedValue.count
        self.selectedSegment = selection.wrappedValue
        
        self._values.updating(view: self, setInitial: false) { view, values in
            view.segmentCount = values.count
            if view.selectedSegment < view.segmentCount, view.selectedSegment >= 0 {
                view.selection = view.selection
            } else {
                view.selection = 0
            }
        }
        
        self._selection.onChange { [weak self] selectedIndex in
            self?.selectedSegment = selectedIndex
        }
    }
    
    public convenience init(
        selection: NBinding<Int>,
        images: NGet<C>
    ) where C.Element == _Image {
        self.init(
            selection: selection,
            values: images
        )
        
        for image in images.wrappedValue.enumerated() {
            self.setImage(image.element, forSegment: image.offset)
        }
        
        self._values.onChange { [weak self] values in
            guard let self else {
                return
            }
            for image in self.values.enumerated() {
                self.setImage(image.element, forSegment: image.offset)
            }
        }
    }
    
    public convenience init(
        selection: NBinding<Int>,
        labels: NGet<C>
    ) where C.Element == String {
        self.init(
            selection: selection,
            values: labels
        )
        
        for label in labels.wrappedValue.enumerated() {
            self.setLabel(label.element, forSegment: label.offset)
        }
        
        self._values.onChange { [weak self] values in
            guard let self else {
                return
            }
            for label in self.values.enumerated() {
                self.setLabel(label.element, forSegment: label.offset)
            }
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchAction() {
        selection = self.selectedSegment
    }
}
#endif
