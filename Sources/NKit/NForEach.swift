import Foundation

@MainActor
internal protocol AnyNForEach {
    var forEachViews: [NView] { get }
    
    func onDataChange(
        changed: @escaping @MainActor () -> Void
    )
}

@MainActor
public final class NForEach<D>: NView, AnyNForEach where D: RandomAccessCollection {
    private let data: D
    private let separator: (() -> NView)?
    private let content: (D.Element) -> [NView]
    
    public init(
        _ data: D,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping /*@MainActor*/ (D.Element) -> [NView]
    ) {
        self.data = data
        self.separator = separator
        self.content = content
    }
    
    public convenience init<N>(
        _ data: NBinding<N>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping /*@MainActor*/ (D.Element) -> [NView]
    ) where N: RandomAccessCollection, D == NGet<N> {
        self.init(
            data.get,
            separator: separator,
            content: content
        )
    }
    
    internal var forEachViews: [NView] {
        var views: [NView] = []
        
        for element in data.enumerated() {
            if element.offset != 0, let separator = separator {
                views.append(separator())
            }
            
            views.append(contentsOf: content(element.element))
        }
        
        return views
    }
}

extension NForEach {
    internal func onDataChange(
        changed: @escaping @MainActor () -> Void
    ) {
        guard let changeable = data as? Changeable else {
            return
        }
        
        changeable.onAnyChange {
            changed()
        }
    }
}
