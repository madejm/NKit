import Foundation

@MainActor
public final class NForEach: NView {
    private let separator: (() -> NView)?
    private let engine: NForEachEngine
    
    @_disfavoredOverload
    public init<D>(
        _ data: D,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (D.Element) -> [NView]
    ) where D: RandomAccessCollection {
        self.separator = separator
        self.engine = NForEachConstantEngine(
            data: data,
            content: content
        )
        self.engine.setOwner(self)
    }
    
    @_disfavoredOverload
    public convenience init<C>(
        _ data: NBinding<C>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (NGet<C>.Element) -> [NView]
    ) where C: RandomAccessCollection {
        self.init(
            data.get,
            separator: separator,
            content: content
        )
    }
    
    public init<C>(
        _ data: NGet<C>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (NGet<C.Element?>) -> [NView]
    ) where C: RandomAccessCollection, C: Equatable, C.Element: Hashable {
        self.separator = separator
        self.engine = NForEachDynamicCachableEngine(
            data: data,
            content: content
        )
        self.engine.setOwner(self)
    }
    
    public convenience init<C>(
        _ data: NBinding<C>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (NGet<C.Element?>) -> [NView]
    ) where C: RandomAccessCollection, C: Equatable, C.Element: Hashable {
        self.init(
            data.get,
            separator: separator,
            content: content
        )
    }
    
    public convenience init<Key, Value>(
        _ dictionary: [Key: Value],
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (_ key: Key, _ value: Value) -> [NView]
    ) where Key: Comparable {
        let array: [Key] = Array(dictionary.keys).sorted()
        
        self.init(
            array,
            separator: separator,
            content: { key in
                content(key, dictionary[key]!)
            }
        )
    }
    
    deinit {
        print_debug("✨ DEINIT NForEach")
    }
}

extension NForEach: AnyNForEach {
    internal func isTheSameAs(_ other: AnyNForEach) -> Bool {
        guard let another = other as? Self else {
            return false
        }
        return another === self
    }
    
    internal func setNForEachParent(_ parent: NView) {
        self.engine.setNForEachParent(parent)
    }
    
    internal var viewsCountInCache: Int {
        self.engine.viewsCountInCache
    }
    
    internal func viewsCountInCache(until end: AnyNForEach) -> (count: Int, stop: Bool) {
        self.engine.viewsCountInCache(until: end)
    }
    
    internal var forEachViews: [NView] {
        self.engine.forEachViews
    }
    
    internal func onDataChange(
        changed: @escaping (_ viewsBeforeMe: Int, _ changes: [NChange<NView>]) -> Void
    ) {
        self.engine.onDataChange(changed: changed)
    }
    
    internal func clearCache() {
        self.engine.clearCache()
    }
}
