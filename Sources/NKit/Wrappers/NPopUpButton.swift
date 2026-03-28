import Foundation
#if canImport(AppKit)
import AppKit
#if DEBUG
import SwiftUI
#endif

extension NPopUpButton {
    
    public convenience init(
        selection: NBinding<Int>,
        labels: C
    ) {
        self.init(
            selection: selection,
            labels: .constant(labels)
        )
    }
}

open class NPopUpButton<C>: NSPopUpButton
where C: Equatable, C: RandomAccessCollection, C.Index == Int, C.Element == String {
    
    @NBinding private var selection: Int
    @NGet private var labels: C
    
    public init(
        selection: NBinding<Int>,
        labels: NGet<C>
    ) {
        self._selection = selection
        self._labels = labels
        
        super.init(frame: .zero, pullsDown: false)
        
        self.target = self
        self.action = #selector(touchAction)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        
        for label in labels.wrappedValue {
            addItem(withTitle: label)
        }
        
        bind(labels, setInitial: false) { [weak self] labels in
            guard let self else {
                return
            }
            removeAllItems()
            for label in labels {
                addItem(withTitle: label)
            }
            
            let selectedIndex: Int = selection.wrappedValue
            if selectedIndex < labels.count {
                selectItem(at: selectedIndex)
            } else {
                selection.wrappedValue = 0
            }
        }
        
        bind(selection, setInitial: true) { [weak self] selectedIndex in
            guard let self else {
                return
            }
            guard selectedIndex < numberOfItems else {
                return
            }
            selectItem(at: selectedIndex)
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchAction() {
        selection = indexOfSelectedItem
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
private enum NPopUpButton_PreviewHelper {
    enum Values: String, Equatable, CaseIterable {
        case _3 = "3 values"
        case _5 = "5 values"
        
        var labels: [String] {
            switch self {
            case ._3:
                return [
                    "house",
                    "person",
                    "book"
                ]
            case ._5:
                return [
                    "car",
                    "airplane",
                    "bus",
                    "ferry",
                    "tram"
                ]
            }
        }
    }
}

@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState<NPopUpButton_PreviewHelper.Values> var values = ._3
    @Previewable @NState<Int> var selectedIndex = 0
    
    NViewPreview {
        NVStack(alignment: .center, spacing: 8) {
            NHStack(spacing: 8) {
                NText($selectedIndex.map())
            }
            
            NPopUpButton(
                selection: $values.map(
                    up: {
                        NPopUpButton_PreviewHelper.Values.allCases.firstIndex(of: $0)!
                    },
                    down: {
                        NPopUpButton_PreviewHelper.Values.allCases[$0]
                    }
                ),
                labels: NPopUpButton_PreviewHelper.Values.allCases.map(\.rawValue)
            )
            NPopUpButton(
                selection: $selectedIndex,
                labels: $values.labels
            )
            NPopUpButton(
                selection: $selectedIndex,
                labels: $values.labels
            )
        }
        .padding(20)
    }
}
#endif
#endif
