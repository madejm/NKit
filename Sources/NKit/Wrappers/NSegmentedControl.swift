import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension NSegmentedControl where C.Element == _Image {
    
    public convenience init(
        selection: NBinding<_Image>,
        images: NGet<C>
    ) {
        self.init(
            selection: selection.map(
                up: { image in
                    images.wrappedValue.firstIndex(of: image) ?? 0
                },
                down: { index in
                    images.wrappedValue[index]
                }
            ),
            images: images
        )
    }
    
    public convenience init(
        selection: NBinding<_Image>,
        images: C
    ) {
        self.init(
            selection: selection.map(
                up: { image in
                    images.firstIndex(of: image) ?? 0
                },
                down: { index in
                    images[index]
                }
            ),
            images: .constant(images)
        )
    }
    
    public convenience init(
        selection: NBinding<Int>,
        images: C
    ) {
        self.init(
            selection: selection,
            images: .constant(images)
        )
    }
}

extension NSegmentedControl where C.Element == String {
    
    public convenience init(
        selection: NBinding<String>,
        labels: NGet<C>
    ) {
        self.init(
            selection: selection.map(
                up: { label in
                    labels.wrappedValue.firstIndex(of: label) ?? 0
                },
                down: { index in
                    labels.wrappedValue[index]
                }
            ),
            labels: labels
        )
    }
    
    public convenience init(
        selection: NBinding<String>,
        labels: C
    ) {
        self.init(
            selection: selection.map(
                up: { label in
                    labels.firstIndex(of: label) ?? 0
                },
                down: { index in
                    labels[index]
                }
            ),
            labels: .constant(labels)
        )
    }
    
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

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
private enum NSegmentedControl_PreviewHelper {
    enum Values: String, Equatable, CaseIterable {
        case _3 = "3 values"
        case _5 = "5 values"
    }
    
    static let images3: [_Image] = [
        _Image(systemName: "house")!,
        _Image(systemName: "person")!,
        _Image(systemName: "book")!
    ]
    static let images5: [_Image] = [
        _Image(systemName: "car")!,
        _Image(systemName: "airplane")!,
        _Image(systemName: "bus")!,
        _Image(systemName: "ferry")!,
        _Image(systemName: "tram")!
    ]
    static let labels3: [String] = [
        "house",
        "person",
        "book"
    ]
    static let labels5: [String] = [
        "car",
        "airplane",
        "bus",
        "ferry",
        "tram"
    ]
}

@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState<NSegmentedControl_PreviewHelper.Values> var values = ._3
    @Previewable @NState<Int> var selectedIndex = 0
    @Previewable @NState<[_Image]> var images = NSegmentedControl_PreviewHelper.images3
    @Previewable @NState<[String]> var labels = NSegmentedControl_PreviewHelper.labels3
    
    var selectedImage: NBinding<_Image> = $selectedIndex.map(
        up: { index in
            images[index]
        },
        down: { image in
            images.firstIndex(of: image) ?? 0
        }
    )
    
    var selectedLabel: NBinding<String> = $selectedIndex.map(
        up: { index in
            labels[index]
        },
        down: { label in
            labels.firstIndex(of: label) ?? 0
        }
    )
    
    NViewPreview {
        NVStack(alignment: .center, spacing: 8) {
            NHStack(spacing: 8) {
                NImage(selectedImage)
                    .frame(width: 24, height: 24)
                
                NText($selectedIndex.map())
                NText(selectedLabel)
            }
            
            NSegmentedControl(
                selection: $selectedIndex,
                images: $images.get
            )
            
            NSegmentedControl(
                selection: selectedImage,
                images: $images.get
            )
            
            NSegmentedControl(
                selection: $selectedIndex,
                labels: $labels.get
            )
             
            NSegmentedControl(
                selection: selectedLabel,
                labels: $labels.get
            )
            
            NSegmentedControl(
                selection: $values.map(
                    up: { $0.rawValue },
                    down: { .init(rawValue: $0)! }
                ),
                labels: NSegmentedControl_PreviewHelper.Values.allCases.map { $0.rawValue }
            )
        }
        .onChange(of: $values) { values in
            switch values {
            case ._3:
                images = NSegmentedControl_PreviewHelper.images3
                labels = NSegmentedControl_PreviewHelper.labels3
            case ._5:
                images = NSegmentedControl_PreviewHelper.images5
                labels = NSegmentedControl_PreviewHelper.labels5
            }
        }
        .frame(width: 300)
        .padding(8)
    }
}
#endif
