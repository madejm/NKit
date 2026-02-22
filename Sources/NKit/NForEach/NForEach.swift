import Foundation
import FixedArray

@MainActor
public final class NForEach: NView {
    private let separator: (() -> NView)?
    private let engine: NForEachEngine
    
    internal let releaseChecker = ReleaseChecker(onlyImportant: true)
    
    #if DEBUG
    nonisolated
    internal let describeTypeOfData: String
    #endif
    
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
        self.describeTypeOfData = self.engine.describeTypeOfData
        self.engine.setOwner(self)
        self.releaseChecker.prepare(self)
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
        animateChanges: Bool = false,
        @NViewBuilder content: @escaping (NGet<C.Element>) -> [NView]
    ) where C: RandomAccessCollection, C: Equatable, C.Element: Hashable {
        self.separator = separator
        self.engine = NForEachDynamicCachableEngine(
            data: data,
            animateChanges: animateChanges,
            content: content
        )
        self.describeTypeOfData = self.engine.describeTypeOfData
        self.engine.setOwner(self)
        self.releaseChecker.prepare(self)
    }
    
    public convenience init<C>(
        _ data: NBinding<C>,
        separator: (() -> NView)? = nil,
        animateChanges: Bool = false,
        @NViewBuilder content: @escaping (NGet<C.Element>) -> [NView]
    ) where C: RandomAccessCollection, C: Equatable, C.Element: Hashable {
        self.init(
            data.get,
            separator: separator,
            animateChanges: animateChanges,
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
    
    public init<Size, Element>(
        constantSize data: NGet<FixedArray<Size, Element>>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (NGet<Element>) -> [NView]
    ) {
        self.separator = separator
        self.engine = NForEachConstantEngine(
            data: data,
            content: content
        )
        self.describeTypeOfData = self.engine.describeTypeOfData
        self.engine.setOwner(self)
        self.releaseChecker.prepare(self)
    }
    
    public convenience init<Size, Element>(
        constantSize data: NBinding<FixedArray<Size, Element>>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (NGet<Element>) -> [NView]
    ) {
        self.init(
            data.get,
            separator: separator,
            content: content
        )
    }
    
    #if swift(>=6.2)
    @available(macOS 26.0, iOS 26.0, *)
    public init<let count: Int, Element>(
        _ data: NGet<InlineArray<count, Element>>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (NGet<Element>) -> [NView]
    ) where Element: Equatable {
        self.separator = separator
        self.engine = NForEachConstantEngine(
            data: data.map(),
            content: content
        )
        self.describeTypeOfData = self.engine.describeTypeOfData
        self.engine.setOwner(self)
        self.releaseChecker.prepare(self)
    }
    
    @available(macOS 26.0, iOS 26.0, *)
    public convenience init<let count: Int, Element>(
        _ data: NBinding<InlineArray<count, Element>>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (NGet<Element>) -> [NView]
    ) where Element: Equatable {
        self.init(
            data.get,
            separator: separator,
            content: content
        )
    }
    #endif
    
    deinit {
        self.releaseChecker.confirm()
        print_debug("💥 DEINIT NForEach [\(describeTypeOfData)]")
    }
    
    public var body: _View {
        fatalError("NForEach does not produce a body!")
    }
}

extension NForEach {
    //    internal func isTheSameAs(_ other: NForEach) -> Bool {
    //        guard let another = other as? Self else {
    //            return false
    //        }
    //        return another === self
    //    }
    
    internal func setNForEachParent(_ parent: NView) {
        self.engine.setNForEachParent(parent)
    }
    
    internal var forEachViewsCountInCache: Int {
        self.engine.viewsCountInCache
    }
    
    internal func forEachViewsCountInCache(until end: AnyObject) -> (count: Int, stop: Bool) {
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
}

extension NForEach: NCacheable {
    
    internal func weakify() {
        self.engine.weakifyCache()
    }
    
    internal func strongify() {
        self.engine.strongifyCache()
    }
    
    internal func clear() {
        self.engine.clearCache()
    }
}
