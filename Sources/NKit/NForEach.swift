import Foundation

#if DEBUG
import AppKit
#endif

@MainActor
internal protocol AnyNForEach {
    var forEachViews: [NView] { get }
    
    func onDataChange(
        changed: @escaping (_ removeCount: Int, _ changes: [Change<NView>]) -> Void
    )
    
    func clearCache()
    
    var DEBUG_LABEL: String { get }
    var NONCACHABLE_DEBUG_CONTENT: [NView] { get }
}

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
    private var cachedViews: [CachedView?]? = []
    
    let DEBUG_LABEL: String
    var NONCACHABLE_DEBUG_CONTENT: [NView] = []
    
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

@MainActor
internal struct CachedView {
    @MainActor
    private final class CachedElement {
        private var array: [CachedElement]?
        private unowned var object: (NView & AnyObject)? {
            willSet {
                if newValue == nil {
                    lastObjectViewCount = object?.viewsCount
                }
            }
        }
        
        private var lastObjectViewCount: Int?
        
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
        
        var viewsCount: Int {
            if let array {
                return array.reduce(into: 0) { $0 += $1.viewsCount }
            }
            if let object {
                return object.viewsCount
            }
            if let lastObjectViewCount {
                return lastObjectViewCount
            }
            fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
        }
        
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
    
    var isAvailable: Bool = true
    let hash: Int
//    var viewOffset: StackIndex
//    var viewsCount: Int
    private let elements: [CachedElement]
    
    fileprivate init(
        hash: Int,
//        viewOffset: StackIndex,
//        viewsCount: Int,
        views: [NView]
    ) {
        self.hash = hash
//        self.viewOffset = viewOffset
//        self.viewsCount = viewsCount
        
        self.elements = views.map {
            CachedElement(view: $0)
        }
    }
    
    mutating func clear() {
        self.isAvailable = false
        
        for element in elements {
            element.clear()
        }
    }
    
    var views: [NView] {
        self.elements.map {
            $0.view
        }
    }
    
    var viewsCount: Int {
        self.elements.reduce(into: 0) {
            $0 += $1.viewsCount
        }
    }
}

enum Change<View> {
    case remove(at: StackIndex, count: Int)
    
    case keep(views: [View])
    case move(from: StackIndex, to: StackIndex, views: [View])
    case insert(at: StackIndex, views: [View])
}

extension NForEach: AnyNForEach {
    internal var forEachViews: [NView] {
        guard let cachedViews else {
            return []
        }
        
        let newCached: [(oldIndex: NViewIndex, view: CachedView)] = cachedViews
            .compactMap {
                guard let view = $0 else {
                    return nil
                }
                return (oldIndex: NViewIndex(rawValue: 0), view: view)
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
    
    internal func forEachViewsFromCache(newCached: [(oldIndex: NViewIndex, view: CachedView)]) -> [Change<NView>] {
        var changes: [Change<NView>] = []
        
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
                let oldOffset: StackIndex = cachedOld.viewsCount(upTo: cachedView.newIndex)
                
                if oldOffset == currentCount {
//                if cachedView.view.viewOffset == currentCount {
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
        changed: @escaping (_ removeCount: Int, _ changes: [Change<NView>]) -> Void
    ) {
        guard let changeable = data as? Changeable else {
            return
        }
        
        changeable.onSomeChange { [weak self] newValue in
            guard let self else {
                return
            }
            
            let beforeCount: Int = self.cachedViews?.viewsCount ?? 0
            
            guard let hashables = newValue as? [any Hashable] else {
                fatalError("trying to change non hashables")
            }
            guard var cachedCopy = self.cachedViews else {
                return
            }
            
            var viewChanges: [Change<NView>] = []
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
                guard let cachedToClear: CachedView = element.element else {
                    continue
                }
                guard cachedToClear.isAvailable else {
                    continue
                }
                
                let viewOffset: StackIndex = cachedCopy.viewsCount(upTo: element.offset)
                
                let dsc = cachedToClear.views.debugStringValues
                print("🗑️ clearing at: \(viewOffset), count: \(cachedToClear.viewsCount), \(dsc)")
                
                viewChanges.append(.remove(at: viewOffset, count: cachedToClear.viewsCount))
//                cachedToClear.clear()
                cachesToClear.append(cachedToClear)
            }
            
            let changes: [Change<NView>] = viewChanges + self.forEachViewsFromCache(newCached: newCached)
            
            changed(beforeCount, changes)
            
            for i in 0..<cachesToClear.count {
                cachesToClear[i].clear()
            }
        }
    }
    
    func clearCache() {
//        guard let cachedViews else {
//            return
//        }
//        
//        for cachedToClear in cachedViews {
//            cachedToClear?.clear()
//        }
        guard let cachedViewsCount = self.cachedViews?.count else {
            return
        }
        
        for i in 0..<cachedViewsCount {
            self.cachedViews?[i]?.clear()
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
    fileprivate mutating func getCached(hash: Int?) -> (oldIndex: NViewIndex, view: CachedView)? {
        guard let cachedIndex: Int = self.firstIndex(where: {
            guard let element = $0 else {
                return false
            }
            guard element.isAvailable else {
                return false
            }
            return hash == element.hash
        }) else {
            return nil
        }
        
        guard let cachedView: CachedView = self[cachedIndex] else {
            return nil
        }
        self[cachedIndex]?.isAvailable = false
        
        return (NViewIndex(rawValue: cachedIndex), cachedView)
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
    
    @MainActor
    fileprivate func viewsCount(upTo index: Int) -> StackIndex {
        var count: StackIndex = 0
        
        for i in 0..<index {
            if let cached: CachedView = self[i] {
                count += cached.viewsCount
            }
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

protocol CustomIndexDescription {
    static var name: String? { get }
}

extension CustomIndexDescription {
    static var name: String? {
        nil
    }
}

enum StackIndexEnum: CustomIndexDescription {
    static var name: String? { "StackIndex" }
}
typealias StackIndex = CustomIndex<StackIndexEnum>

enum NViewIndexEnum: CustomIndexDescription {
    static var name: String? { "NViewIndex" }
}
typealias NViewIndex = CustomIndex<NViewIndexEnum>

struct CustomIndex<T: CustomIndexDescription>: RawRepresentable, Comparable, Equatable, ExpressibleByIntegerLiteral, CustomStringConvertible {
    
    static func < (lhs: CustomIndex, rhs: CustomIndex) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    init(integerLiteral value: Int) {
        self.rawValue = value
    }
    
    var description: String {
        if let name: String = T.name {
            return "\(name)( \(rawValue) )"
        } else {
            return "CustomIndex<\(String(describing: T.self))>( \(rawValue) )"
        }
    }
}

func == <T>(lhs: CustomIndex<T>, rhs: Int) -> Bool {
    lhs.rawValue == rhs
}

func == <T>(lhs: Int, rhs: CustomIndex<T>) -> Bool {
    lhs == rhs.rawValue
}

func + <T>(lhs: CustomIndex<T>, rhs: CustomIndex<T>) -> CustomIndex<T> {
    .init(rawValue: lhs.rawValue + rhs.rawValue)
}

func + <T>(lhs: CustomIndex<T>, rhs: Int) -> CustomIndex<T> {
    .init(rawValue: lhs.rawValue + rhs)
}

func + <T>(lhs: Int, rhs: CustomIndex<T>) -> CustomIndex<T> {
    .init(rawValue: lhs + rhs.rawValue)
}

func += <T>(lhs: inout CustomIndex<T>, rhs: CustomIndex<T>) {
    lhs.rawValue += rhs.rawValue
}

func += <T>(lhs: inout CustomIndex<T>, rhs: Int) {
    lhs.rawValue += rhs
}

extension Range {
    func intRange<T>() -> Range<Int> where Bound == CustomIndex<T> {
        self.lowerBound.rawValue..<self.upperBound.rawValue
    }
}

extension Array where Element: _View {
    internal subscript(_ index: StackIndex) -> Element {
        get {
            self[index.rawValue]
        }
        set {
            self[index.rawValue] = newValue
        }
    }
}

extension _Stack {
    internal func insertArrangedSubview(_ view: _View, at index: StackIndex) {
        self.insertArrangedSubview(view, at: index.rawValue)
    }
}
