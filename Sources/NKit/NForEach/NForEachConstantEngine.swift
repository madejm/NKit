//
//  NForEachConstantEngine.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@MainActor
internal final class NForEachConstantEngine<D> where D: RandomAccessCollection {
    private let data: D
    private let content: (D.Element) -> [NView]
    private var cachedViews: [CachedView]?
    private var cachedParent: CachedElement?
    private unowned var owner: NForEach!
    
    private var parent: NView? {
        get {
            cachedParent?.element
        }
        set {
            cachedParent = newValue.map {
                CachedElement(
                    view: $0,
                    isStrongified: false,
                    isRoot: false
                )
            }
        }
    }
    
    public init(
        data: D,
        content: @escaping (D.Element) -> [NView]
    ) {
        self.data = data
        self.content = content
    }
    
    #if DEBUG
    nonisolated
    internal var describeTypeOfData: String {
        "CONSTANT <\(String(describing: D.self))>"
    }
    #endif
}

extension NForEachConstantEngine: NForEachEngine {
    func setOwner(_ owner: NForEach) {
        self.owner = owner
    }
    
    func setNForEachParent(_ parent: NView) {
        self.parent = parent
    }
    
    var viewsCountInCache: Int {
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
    
    func viewsCountInCache(until end: AnyObject) -> (count: Int, stop: Bool) {
//        guard !owner.isTheSameAs(end) else {
        guard owner !== end else {
            return (0, true)
        }
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
    
    var forEachViews: [NView] {
        if let cachedViews {
            let views: [NView] = cachedViews
                .compactMap {
                    $0.views
                }
            return views
        }
        
        let views: [NView] = self.data.map {
            self.content($0)
        }
        
        if let parent {
            views.setParent(parent)
        }
        
        self.cachedViews = [ CachedView(hash: 0, views: views, isStrongified: true, isRoot: true) ]
        return views
    }
    
    func onDataChange(changed: @escaping (Int, [NChange<NView>]) -> Void) {
        print("")
    }
    
    func weakifyCache() {
        print("")
    }
    
    func strongifyCache() {
        print("")
    }
    
    func clearCache() {
        print("")
    }
}
