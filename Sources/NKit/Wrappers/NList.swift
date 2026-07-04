import Foundation
import Combine
#if canImport(AppKit)
import AppKit
#if DEBUG
import SwiftUI
#endif

public class NList<Data>: NScrollView where Data: RandomAccessCollection, Data: Equatable, Data.Element: Equatable, Data.Index == Int {
    
    @NGet private var data: Data
    private let dataSource: DataSource
    
    @inline(__always)
    private var tableView: NSTableView {
        dataSource.tableView
    }
    
    public init(
        data: NGet<Data>,
        selection: NBinding<Int>? = nil,
        _ rowContent: @escaping (NGet<Data.Element>) -> _View
    ) {
        self._data = data
        self.dataSource = .init(
            selection: selection,
            dataCount: {
                data.count
            },
            rowContent: { row in
                rowContent(data[row])
            }
        )
        
        super.init(axes: .vertical, dataSource.tableView)
        
        tableView.headerView = nil
        if #available(macOS 11.0, *) {
            tableView.style = .plain
        }
        tableView.selectionHighlightStyle = .regular
        tableView.usesAutomaticRowHeights = true
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.allowsMultipleSelection = false
        tableView.allowsEmptySelection = false
        tableView.allowsColumnSelection = false
        
        tableView.addTableColumn(NSTableColumn())
        if let selection {
            tableView.selectRowIndexes(.init(integer: selection.wrappedValue), byExtendingSelection: false)
        }
        
        let initialCount: Int = data.wrappedValue.count
        
        data.publisher
            .map(\.count)
            .scan((previous: initialCount, current: initialCount)) { state, newValue in
                (previous: state.current, current: newValue)
            }
            .sink { [unowned self] (previous, current) in
                if previous > current {
                    tableView.removeRows(at: IndexSet(integersIn: current..<previous))
                } else {
                    tableView.insertRows(at: IndexSet(integersIn: previous..<current))
                }
            }
            .store(in: &cancellables)
        
        selection?.onChange { [weak self] selected in
            self?.tableView.selectRowIndexes(.init(integer: selected), byExtendingSelection: false)
        }
    }
}

extension NList {
    public convenience init(
        data: Data,
        selection: NBinding<Data.Element>,
        _ rowContent: @escaping (NGet<Data.Element>) -> _View
    ) where Data: Equatable {
        self.init(
            data: .constant(data),
            selection: selection,
            rowContent
        )
    }
    
    public convenience init(
        data: NGet<Data>,
        selection: NBinding<Data.Element>,
        _ rowContent: @escaping (NGet<Data.Element>) -> _View
    ) where Data: Equatable {
        self.init(
            data: data,
            selection: selection.map(
                up: { element in
                    data.firstIndex { $0.wrappedValue == element } ?? 0
                },
                down: { index in
                    data[index].wrappedValue
                }
            ),
            rowContent
        )
    }
    
    public convenience init(
        data: Data,
        selection: NBinding<Int>? = nil,
        _ rowContent: @escaping (NGet<Data.Element>) -> _View
    ) {
        self.init(
            data: .constant(data),
            selection: selection,
            rowContent
        )
    }
    
    public convenience init(
        data: Data,
        selection: NBinding<Int>? = nil
    ) where Data == [String] {
        self.init(
            data: .constant(data),
            selection: selection
        )
    }
    
    public convenience init(
        data: NGet<Data>,
        selection: NBinding<Int>? = nil
    ) where Data == [String] {
        self.init(
            data: data,
            selection: selection
        ) { (string: NGet<String>) in
            NText(string)
                .padding(.vertical, 4)
        }
    }
}

@MainActor
private final class DataSource: NSObject {
    let tableView: NSTableView = NSTableView()
    private let selection: NBinding<Int>?
    private let dataCount: () -> Int
    private let rowContent: (Int) -> _View
    
    init(
        selection: NBinding<Int>?,
        dataCount: @escaping () -> Int,
        rowContent: @escaping (Int) -> _View
    ) {
        self.selection = selection
        self.dataCount = dataCount
        self.rowContent = rowContent
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension DataSource: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        dataCount()
    }
}

extension DataSource: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        rowContent(row)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        guard let selection else {
            return false
        }
        selection.wrappedValue = row
        return true
    }
}

extension NList {
    @available(macOS 11.0, *)
    public func style(_ style: NSTableView.Style) -> Self {
        tableView.style = style
        return self
    }
}

#if DEBUG
#Preview {
    @NState var elements: Int = 5
    @NState var type: Int = 0
    @NState var selection: Int = 0
    let data: NGet<[String]> = NGet.combine($elements, $type) { elements, type in
        (0..<elements).map {
            "\(type == 0 ? "Element" : "Row") \($0)"
        }
    }
    
    NViewPreview {
        NHStack(hugging: .resize) {
            NVStack {
                NSegmentedControl(selection: $type, labels: ["Element", "Row"])
                NHStack {
                    NText($elements.map())
                    NStepper($elements, range: 1...10)
                }
            }
            NList(
                data: data,
                selection: $selection
            )
            NList(
                data: data,
                selection: $selection
            )
        }
    }
}
#endif
#endif
