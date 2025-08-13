import Foundation

//private protocol NForEachEngine {
//    var forEachViews: [NView] { get }
//    
//    func onDataChange(
//        changed: @escaping (_ removeCount: Int, _ changes: [Change<NView>]) -> Void
//    )
//    
//    func clearCache()
//}
//
//private struct NForEachConstantEngine: NForEachEngine {
//    
//    func onDataChange(
//        changed: @escaping (_ removeCount: Int, _ changes: [Change<NView>]) -> Void
//    ) {
//    }
//    
//    func clearCache() {
//    }
//}
//
//private struct NForEachDynamicEngine: NForEachEngine {
//    
//}

@MainActor
public final class NForEach<D>: NView where D: RandomAccessCollection {
    private let data: D
    private let separator: (() -> NView)?
    private let content: (D.Element) -> [NView]
    private var cachedViews: [CachedView]? = []
    
    let DEBUG_LABEL: String
    var NONCACHABLE_DEBUG_CONTENT: [NView] = []
    private /*unowned*/ var parent: NView?
    
    public init(
        _ data: D,
        separator: (() -> NView)? = nil,
        DEBUG_LABEL: String = "",
        @NViewBuilder content: @escaping (D.Element) -> [NView]
    ) {
        self.data = data
        self.DEBUG_LABEL = DEBUG_LABEL
        self.separator = separator
        self.content = content
    }
    
    public init<Key, Value>(
        _ dictionary: [Key: Value],
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (_ key: D.Element, _ value: Value) -> [NView]
    ) where Key: Comparable, D == Array<Key> {
        let array: [D.Element] = Array(dictionary.keys).sorted()
        
        self.DEBUG_LABEL = ""
        self.data = array
        self.separator = separator
        self.content = { key in
            content(key, dictionary[key]!)
        }
    }
    
    public convenience init<N>(
        _ data: NBinding<N>,
        DEBUG_LABEL: String = "",
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (D.Element) -> [NView]
    ) where N: RandomAccessCollection, D == NGet<N> {
        self.init(
            data.get,
            separator: separator,
            DEBUG_LABEL: DEBUG_LABEL,
            content: content
        )
    }
}

extension NForEach: AnyNForEach {
    func isTheSameAs(_ other: AnyNForEach) -> Bool {
        guard let another = other as? Self else {
            return false
        }
        return another === self
    }
    
    func setNForEachParent(_ parent: NView) {
        self.parent = parent
    }
    
    func countViewsFromParentUntilYouMeetMe() -> Int? {
        guard let parent else {
            return nil
        }
        return parent.countViews(until: self).count
    }
    
    func VIEW_PRINT(indent: Int) -> String {
        var res = ""
        res += indent.indent()
        res += "{ \(DEBUG_LABEL)\n"
        
        if let cachedViews{
            for cachedView: CachedView in cachedViews {
                res += cachedView.views.VIEW_PRINT(indent: indent + 1)
            }
        }
        
        res += indent.indent()
        res += "}\n"
        
        return res
    }
    
    internal var viewsCountInCache: Int {
        guard let cachedViews else {
            return 0
        }
        
        var count: Int = 0
        
        for cachedView: CachedView in cachedViews {
            count += cachedView.viewsCount
        }
        
        return count
    }
    
    internal func viewsCountInCache(until end: AnyNForEach) -> (count: Int, stop: Bool) {
        guard let cachedViews else {
            return (0, false)
        }
        
        var count: Int = 0
        
        for cachedView: CachedView in cachedViews {
            let result: (count: Int, stop: Bool) = cachedView.countViews(until: end)
            count += result.count
            
            if result.stop {
                return (count, true)
            }
        }
        
        return (count, false)
    }
    
    internal var forEachViews: [NView] {
        guard let cachedViews else {
            return []
        }
        
        let newCached: [(oldIndex: NViewIndex, view: CachedView)] = cachedViews
            .map {
                (oldIndex: NViewIndex(rawValue: 0), view: $0)
            }
        
        let views: [NView] = forEachViewsFromCache(newCached: newCached)
            .compactMap {
                switch $0 {
                case .remove:
                    return nil
                case let .keep(views):
                    return views
                case let .move(_, _, views):
                    return views
                case let .insert(_, views):
                    return views
                }
            }
        
        return views
    }
    
    internal func forEachViewsFromCache(newCached: [(oldIndex: NViewIndex, view: CachedView)]) -> [NChange<NView>] {
        var changes: [NChange<NView>] = []
        
        var cachedOld: [(oldIndex: NViewIndex, view: CachedView)] = newCached
        var cachedNew: [CachedView] = []
        
        var currentCount: Int = 0
        
        for element in data.enumerated() {
            let hash: Int? = elementHash(element.element)
            let cachedView: (newIndex: NViewIndex, oldIndex: NViewIndex, view: CachedView)? = cachedOld.getCached(hash: hash)
            
            if let cachedView {
                let viewsCount: Int = cachedView.view.viewsCount
                let newCachedView: CachedView = cachedView.view
//                newCachedView.viewsCount = viewsCount
                
                let newOffset: StackIndex = StackIndex(rawValue: currentCount)
//                let oldOffset: StackIndex = cachedOld.viewsCount(upTo: cachedView.newIndex)
                let oldOffset: StackIndex = self.cachedViews!.viewsCount(upTo: cachedView.oldIndex.rawValue)
                
//                if oldOffset == currentCount {
                if element.offset == cachedView.oldIndex {
                    changes.append(.keep(views: newCachedView.views))
                    
                    let dsc = newCachedView.views.debugStringValues
                    print("🤝 keeping: \(dsc)")
                } else {
                    changes.append(.move(
                        from: oldOffset,
                        to: newOffset,
                        views: newCachedView.views
                    ))
                    
                    let dsc = newCachedView.views.debugStringValues
                    print("👉 moving from: \(oldOffset), to: \(newOffset), \(dsc)")
                }
                
//                newCachedView.viewOffset = newOffset
                cachedNew.append(newCachedView)
                currentCount += viewsCount
            } else {
                let newContents: [NView] = content(element.element)
                if let parent {
                    newContents.setParent(parent)
                }
                
                let newViewsCount: Int = newContents.viewsCount
                let newOffset: StackIndex = StackIndex(rawValue: currentCount)
                
                let newCachedView: CachedView = .init(
                    hash: hash ?? 0,
//                    viewOffset: newOffset,
//                    viewsCount: newViewsCount,
                    views: newContents
                )
                
                let dsc = newContents.debugStringValues
                print("👉 inserting at: \(newOffset), count: \(newViewsCount), \(dsc)")
                
                changes.append(.insert(at: newOffset, views: newContents))
                cachedNew.append(newCachedView)
                
                currentCount += newViewsCount
            }
        }
        
        if cachedOld.contains(where: { $0.view.isAvailable }) {
            fatalError("this should be empty")
        }
        
        for c in 0..<cachedNew.count {
            cachedNew[c].isAvailable = true
        }
        
        self.cachedViews = cachedNew
        
        self.NONCACHABLE_DEBUG_CONTENT = cachedNew.flatMap(\.views)
        
        return changes
//        var viewsWithSeparators: [NView] = []
//        
//        for element in views.enumerated() {
//            if element.offset != 0, let separator = separator {
//                viewsWithSeparators.append(separator())
//            }
//            
//            viewsWithSeparators.append(element.element)
//        }
//        
//        return viewsWithSeparators
    }
    
    internal func onDataChange(
        changed: @escaping (_ viewsBeforeMe: Int, _ changes: [NChange<NView>]) -> Void
    ) {
        guard let changeable = data as? Changeable else {
            return
        }
        
        changeable.onSomeChange { [weak self] newValue in
            guard let self else {
                return
            }
            
//            let beforeCount: Int = self.cachedViews?.viewsCount ?? 0
            
            guard let hashables = newValue as? [any Hashable] else {
                fatalError("trying to change non hashables")
            }
            guard var cachedCopy = self.cachedViews else {
                return
            }
            
            var viewChanges: [NChange<NView>] = []
            var newCached: [(oldIndex: NViewIndex, view: CachedView)] = []
            
            for hashable in hashables {
                let newHash: Int = hashable.hashValue
                
                guard let cachedView: (oldIndex: NViewIndex, view: CachedView) = cachedCopy.getCached(hash: newHash) else {
                    continue
                }
                newCached.append(cachedView)
            }
            
            var cachesToClear: [CachedView] = []
            
            for element in cachedCopy.enumerated() {
                let cachedToClear: CachedView = element.element
                
                guard cachedToClear.isAvailable else {
                    continue
                }
                
                let viewOffset: StackIndex = cachedCopy.viewsCount(upTo: element.offset)
                
                let dsc = cachedToClear.views.debugStringValues
                print("🗑️ clearing at: \(viewOffset), count: \(cachedToClear.viewsCount), \(dsc)")
                
                viewChanges.append(.remove(at: viewOffset, count: cachedToClear.viewsCount))
                cachesToClear.append(cachedToClear)
            }
            
            let changes: [NChange<NView>] = viewChanges + self.forEachViewsFromCache(newCached: newCached)
            
            let viewsBeforeMe: Int? = countViewsFromParentUntilYouMeetMe()
            
//            changed(beforeCount, changes)
            changed(viewsBeforeMe ?? 0, changes)
            
            for i in 0..<cachesToClear.count {
                cachesToClear[i].clear()
            }
        }
    }
    
    internal func clearCache() {
        guard let cachedViewsCount = self.cachedViews?.count else {
            return
        }
        
        for i in 0..<cachedViewsCount {
            self.cachedViews?[i].clear()
        }
        
        self.cachedViews = nil
    }
}

extension NForEach {
//    private func DEBUG_HASHABLE(_ element: D.Element) -> (any Hashable)? {
//        guard let nAnyGet = element as? any NAnyGet else {
//            return nil
//        }
//        guard let optional: AnyHashable? = nAnyGet.wrappedValue as? AnyHashable? else {
//            return nil
//        }
//        guard let value: AnyHashable = optional else {
//            return nil
//        }
//        return value
//    }
    
    private func elementHash(_ element: D.Element) -> Int? {
        guard let nAnyGet = element as? any NAnyGet else {
            return nil
        }
        guard let optional: AnyHashable? = nAnyGet.wrappedValue as? AnyHashable? else {
            return nil
        }
        guard let value: AnyHashable = optional else {
            return nil
        }
        
        let hash = value.hashValue
        return hash
    }
}

extension Array where Element == CachedView {
    fileprivate mutating func getCached(hash: Int?) -> (oldIndex: NViewIndex, view: CachedView)? {
        guard let cachedIndex: Int = self.firstIndex(where: {
            guard $0.isAvailable else {
                return false
            }
            return hash == $0.hash
        }) else {
            return nil
        }
        
        let cachedView: CachedView = self[cachedIndex]
        self[cachedIndex].isAvailable = false
        
        return (NViewIndex(rawValue: cachedIndex), cachedView)
    }
    
    @MainActor
    fileprivate var viewsCount: Int {
        var count: Int = 0
        
        for cached in self {
            let views: [NView] = cached.views
            count += views.viewsCount
        }
        
        return count
    }
    
    @MainActor
    fileprivate func viewsCount(upTo index: Int) -> StackIndex {
        var count: StackIndex = 0
        
        for i in 0..<index {
            let cached: CachedView = self[i]
            count += cached.viewsCount
        }
        
        return count
    }
}

extension Array where Element == (oldIndex: NViewIndex, view: CachedView) {
    fileprivate mutating func getCached(hash: Int?) -> (newIndex: NViewIndex, oldIndex: NViewIndex, view: CachedView)? {
        guard let cachedIndex: Int = self.firstIndex(where: {
            guard $0.view.isAvailable else {
                return false
            }
            let oldHash = $0.view.hash
            return oldHash == hash
        }) else {
            return nil
        }
        
        let cachedView = self[cachedIndex]
        self[cachedIndex].view.isAvailable = false
        
        return (NViewIndex(rawValue: cachedIndex), cachedView.oldIndex, cachedView.view)
    }
    
    @MainActor
    fileprivate func viewsCount(upTo index: NViewIndex) -> StackIndex {
        var count: StackIndex = 0
        
        for i in 0..<index.rawValue {
            let cached: CachedView = self[i].view
            count += cached.viewsCount
        }
        
        return count
    }
}
