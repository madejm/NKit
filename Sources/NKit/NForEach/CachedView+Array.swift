//
//  CachedView+Array.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

extension Array where Element == CachedView {
    internal mutating func getCached(hash: Int?) -> (oldIndex: NViewIndex, view: CachedView)? {
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
    internal var viewsCount: Int {
        var count: Int = 0
        
        for cached in self {
            let views: [NView] = cached.views
            count += views.viewsCount
        }
        
        return count
    }
    
    @MainActor
    internal func viewsCount(upTo index: Int) -> StackIndex {
        var count: StackIndex = 0
        
        for i in 0..<index {
            let cached: CachedView = self[i]
            count += cached.viewsCount
        }
        
        return count
    }
}

extension Array where Element == (oldIndex: NViewIndex, view: CachedView) {
    internal mutating func getCached(hash: Int?) -> (newIndex: NViewIndex, oldIndex: NViewIndex, view: CachedView)? {
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
    internal func viewsCount(upTo index: NViewIndex) -> StackIndex {
        var count: StackIndex = 0
        
        for i in 0..<index.rawValue {
            let cached: CachedView = self[i].view
            count += cached.viewsCount
        }
        
        return count
    }
}
