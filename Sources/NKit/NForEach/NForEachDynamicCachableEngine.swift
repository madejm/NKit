//
//  NForEachDynamicEngine.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@MainActor
internal final class NForEachDynamicCachableEngine<C>
where C: RandomAccessCollection, C: Equatable, C.Element: Hashable {
    private let data: NGet<C>
    private let animateChanges: Bool
    private let content: (NGet<C.Element>) -> [NView]
    private var cachedViews: [CachedView]? = []
    private var isCacheStrongified: Bool = false
    private var cachedParent: CachedElement?
    private unowned var owner: NForEach!
    
    private var parent: NView? {
        get {
            cachedParent?.element
        }
        set {
            cachedParent = newValue.map {
                CachedElement(view: $0, isStrongified: false)
            }
        }
    }
    
    public init(
        data: NGet<C>,
        animateChanges: Bool,
        content: @escaping (NGet<C.Element>) -> [NView]
    ) {
        self.data = data
        self.animateChanges = animateChanges
        self.content = content
    }
}

extension NForEachDynamicCachableEngine: NForEachEngine {
    internal func setOwner(_ owner: NForEach) {
        self.owner = owner
    }
    
    internal func setNForEachParent(_ parent: NView) {
        self.parent = parent
    }
    
    internal var viewsCountInCache: Int {
        guard let cachedViews else {
            return 0
        }
        
        var count: Int = 0
        
        for cachedView: CachedView in cachedViews {
            count += cachedView.viewsCount
//            count += cachedView.viewsCountInCache
        }
        
        return count
    }
    
    internal func viewsCountInCache(until end: AnyObject) -> (count: Int, stop: Bool) {
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
            .enumerated()
            .map {
                (oldIndex: NViewIndex(rawValue: $0.offset), view: $0.element)
            }
        
        let views: [NView] = forEachViewsFromCache(newCached: newCached)
            .compactMap {
                $0.views
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
                cachedView.view.strongify()
                
                let viewsCount: Int = cachedView.view.viewsCount
//                let viewsCount: Int = cachedView.view.viewsCountInCache
                let newCachedView: CachedView = cachedView.view
                
                let newOffset: StackIndex = StackIndex(rawValue: currentCount)
//                let oldOffset: StackIndex = cachedOld.viewsCount(upTo: cachedView.newIndex)
                let oldOffset: StackIndex = self.cachedViews!.viewsCount(upTo: cachedView.oldIndex.rawValue)
                
//                if oldOffset == currentCount {
                if element.offset == cachedView.oldIndex {
                    changes.append(.keep(views: newCachedView.views))
                    
                    print_debug("🤝 keeping:", newCachedView.views.debugStringValues)
                } else {
                    changes.append(.move(
                        from: oldOffset,
                        to: newOffset,
                        views: newCachedView.views,
                        animated: animateChanges
                    ))
                    
                    print_debug("👉 moving from: \(oldOffset), to: \(newOffset),", newCachedView.views.debugStringValues)
                }
                
                cachedView.view.weakify()
                
                cachedNew.append(newCachedView)
                currentCount += viewsCount
            } else {
                let newContents: [NView] = content(element.element)
                if let parent {
                    newContents.setParent(parent)
                }
                
                let newViewsCount: Int = newContents.viewsCount
//                let newViewsCount: Int = newContents.viewsCountInCache
                let newOffset: StackIndex = StackIndex(rawValue: currentCount)
                
                let newCachedView: CachedView = .init(
                    hash: hash ?? 0,
                    views: newContents,
                    isStrongified: self.isCacheStrongified
                )
                
                print_debug("👉 inserting at: \(newOffset), count: \(newViewsCount),", newContents.debugStringValues)
                
                changes.append(.insert(at: newOffset, views: newContents, animated: animateChanges))
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
    
    internal func onDataChange(changed: @escaping (Int, [NChange<NView>]) -> Void) {
        data.onChange { [weak self] (newValue: C) in
            guard let self else {
                return
            }
            guard var cachedCopy = self.cachedViews else {
                return
            }
            
            var viewChanges: [NChange<NView>] = []
            var newCached: [(oldIndex: NViewIndex, view: CachedView)] = []
            
            for hashable in newValue {
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
                
//                print_debug("🗑️ clearing at: \(viewOffset), count:", cachedToClear.viewsCount, cachedToClear.views.debugStringValues)
                print_debug("🗑️ clearing at: \(viewOffset), count:", cachedToClear.viewsCount)
                
                viewChanges.append(.remove(
                    at: viewOffset,
                    count: cachedToClear.viewsCount,
                    animated: animateChanges
                ))
                cachesToClear.append(cachedToClear)
            }
            
            let changes: [NChange<NView>] = viewChanges + self.forEachViewsFromCache(newCached: newCached)
            
            let viewsBeforeMe: Int? = self.countViewsFromParentUntilYouMeetTheOwner()
            
            changed(viewsBeforeMe ?? 0, changes)
            
            for i in 0..<cachesToClear.count {
                cachesToClear[i].clear()
            }
        }
    }
    
    internal func weakifyCache() {
        guard let indices = self.cachedViews?.indices else {
            return
        }
        
        self.isCacheStrongified = false
        
        for index in indices {
            self.cachedViews?[index].weakify()
        }
    }
    
    internal func strongifyCache() {
        guard let indices = self.cachedViews?.indices else {
            return
        }
        
        self.isCacheStrongified = true
        
        for index in indices {
            self.cachedViews?[index].strongify()
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

extension NForEachDynamicCachableEngine {
    private func countViewsFromParentUntilYouMeetTheOwner() -> Int? {
        guard let parent else {
            return nil
        }
        return parent.countViews(until: owner).count
    }
}
