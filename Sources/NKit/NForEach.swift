import Foundation

#if DEBUG
import AppKit
#endif

@MainActor
internal protocol AnyNForEach {
    var forEachViews: [NView] { get }
    
    func onDataChange(
        changed: @escaping (_ removeCount: Int, _ newViews: [NView]) -> Void
    )
    
    func clearCache()
}

@MainActor
public final class NForEach<D>: NView where D: RandomAccessCollection {
    private let data: D
    private let separator: (() -> NView)?
    private let content: (D.Element) -> [NView]
    private var cachedViews: [CachedView?]? = []
    
    public init(
        _ data: D,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (D.Element) -> [NView]
    ) {
        self.data = data
        self.separator = separator
        self.content = content
    }
    
    public init<Key, Value>(
        _ dictionary: [Key: Value],
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (_ key: D.Element, _ value: Value) -> [NView]
    ) where Key: Comparable, D == Array<Key> {
        let array: [D.Element] = Array(dictionary.keys).sorted()
        
        self.data = array
        self.separator = separator
        self.content = { key in
            content(key, dictionary[key]!)
        }
    }
    
    public convenience init<N>(
        _ data: NBinding<N>,
        separator: (() -> NView)? = nil,
        @NViewBuilder content: @escaping (D.Element) -> [NView]
    ) where N: RandomAccessCollection, D == NGet<N> {
        self.init(
            data.get,
            separator: separator,
            content: content
        )
    }
}

internal struct CachedView {
    private final class CachedElement {
        private var array: [CachedElement]?
        private unowned var object: (NView & AnyObject)?
        
        init(view: NView) {
            if let array = view as? [NView] {
                self.array = array.map {
                    CachedElement(view: $0)
                }
            } else if let object = view as? (NView & AnyObject) {
                self.object = object
            } else {
                fatalError("Trying to cache non object value: \(String(describing: type(of: view)))!")
            }
        }
        
        var view: NView {
            if let array {
                let mapped: [NView] = array.map { $0.view }
                return mapped
            }
            if let object {
                return object
            }
            fatalError("Cached element was deallocated!")
        }
        
        @MainActor
        func clear() {
            if let array {
                for element in array {
                    element.clear()
                }
            }
            if let object {
                if let anyNForEach = object as? AnyNForEach {
                    anyNForEach.clearCache()
                }
                self.object = nil
            }
        }
    }
    
    let hash: Int
    private let elements: [CachedElement]
    
    fileprivate init(
        hash: Int,
        views: [NView]
    ) {
        self.hash = hash
        
        self.elements = views.map {
            CachedElement(view: $0)
        }
    }
    
    @MainActor
    func clear() {
        for element in elements {
            element.clear()
        }
    }
    
    var views: [NView] {
        self.elements.map {
            $0.view
        }
    }
}

extension NForEach: AnyNForEach {
    internal var forEachViews: [NView] {
        var views: [NView] = []
        
        if self.cachedViews == nil {
            return []
        }
        
        var cachedOld: [CachedView?] = self.cachedViews ?? []
        var cachedNew: [CachedView] = []
        
        for element in data.enumerated() {
            let hash: Int? = elementHash(element.element)
            let cachedView: CachedView? = cachedOld.getCached(hash: hash)
            
            if let cachedView {
                views.append(contentsOf: cachedView.views)
                cachedNew.append(cachedView)
            } else {
                let newContents: [NView] = content(element.element)
                let newCachedView: CachedView = .init(
                    hash: hash ?? 0,
                    views: newContents
                )
                views.append(contentsOf: newContents)
                cachedNew.append(newCachedView)
            }
        }
        
        self.cachedViews = cachedOld.compactMap(\.self) + cachedNew
        
        var viewsWithSeparators: [NView] = []
        
        for element in views.enumerated() {
            if element.offset != 0, let separator = separator {
                viewsWithSeparators.append(separator())
            }
            
            viewsWithSeparators.append(element.element)
        }
        
        return viewsWithSeparators
    }
    
    internal func onDataChange(
        changed: @escaping (_ removeCount: Int, _ newViews: [NView]) -> Void
    ) {
        guard let changeable = data as? Changeable else {
            return
        }
        
        changeable.onSomeChange { [weak self] newValue in
            guard let self else {
                return
            }
            
            let beforeCount: Int = self.cachedViews?.viewsCount ?? 0
            
            if let hashables = newValue as? [any Hashable],
               var cachedCopy = self.cachedViews {
                
                var newCached: [CachedView?] = []
                
                for hashable in hashables {
                    let newHash: Int = hashable.hashValue
                    let cachedView: CachedView? = cachedCopy.getCached(hash: newHash)
                    newCached.append(cachedView)
                }
                
                self.cachedViews = newCached
                
                for cachedToClear in cachedCopy {
                    cachedToClear?.clear()
                }
            }
            
            let newViews: [NView] = self.forEachViews
            
            changed(beforeCount, newViews)
        }
    }
    
    func clearCache() {
        guard let cachedViews else {
            return
        }
        
        for cachedToClear in cachedViews {
            cachedToClear?.clear()
        }
        
        self.cachedViews = nil
    }
}

extension NForEach {
    private func DEBUG_HASHABLE(_ element: D.Element) -> (any Hashable)? {
        guard let nAnyGet = element as? any NAnyGet else {
            return nil
        }
        guard let optional: AnyHashable? = nAnyGet.wrappedValue as? AnyHashable? else {
            return nil
        }
        guard let value: AnyHashable = optional else {
            return nil
        }
        return value
    }
    
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

extension Array where Element == CachedView? {
    fileprivate mutating func getCached(hash: Int?) -> CachedView? {
        let cachedIndex: Int? = self.firstIndex {
            guard let oldHash = $0?.hash else {
                return false
            }
            return oldHash == hash
        }
        
        let cachedView: CachedView? = {
            guard let cachedIndex else {
                return nil
            }
            let view = self[cachedIndex]
            self.remove(at: cachedIndex)
            return view
        }()
        
        return cachedView
    }
    
    @MainActor
    fileprivate var viewsCount: Int {
        var count: Int = 0
        
        for cached in self {
            if let views: [NView] = cached?.views {
                count += views.viewsCount
            }
        }
        
        return count
    }
}
