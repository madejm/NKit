//
//  NForEachConstantEngine.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

internal final class NForEachConstantEngine<D> where D: RandomAccessCollection {
    private let data: D
    private let content: (D.Element) -> [NView]
    private var views: [NView]?
    private /*unowned*/ var parent: NView?
    private unowned var owner: NForEach!
    
    public init(
        data: D,
        content: @escaping (D.Element) -> [NView]
    ) {
        self.data = data
        self.content = content
    }
}

extension NForEachConstantEngine: NForEachEngine {
    func setOwner(_ owner: NForEach) {
        self.owner = owner
    }
    
    func setNForEachParent(_ parent: NView) {
        self.parent = parent
    }
    
    var viewsCountInCache: Int {
        guard let views else {
            return 0
        }
        
        return views.reduce(into: 0) {
            $0 += $1.viewsCount
        }
    }
    
    func viewsCountInCache(until end: NForEach) -> (count: Int, stop: Bool) {
//        guard !owner.isTheSameAs(end) else {
        guard owner !== end else {
            return (0, true)
        }
        guard let views else {
            return (0, false)
        }
        
        var count: Int = 0
        
        for view in views {
            let result: (count: Int, stop: Bool) = view.countViews(until: end)
            count += result.count
            
            if result.stop {
                return (count, true)
            }
        }
        
        return (count, false)
    }
    
    var forEachViews: [NView] {
        if let views {
            return views
        }
        
        let views: [NView] = self.data.map {
            self.content($0)
        }
        
        if let parent {
            views.setParent(parent)
        }
        
        self.views = views
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
