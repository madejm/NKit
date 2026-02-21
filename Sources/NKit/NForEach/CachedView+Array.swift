//
//  CachedView+Array.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

extension Array {
    @MainActor
    internal mutating func getCached<H: Equatable>(hash: H?) -> (oldIndex: NViewIndex, view: CachedView<H>)?
    where Element == CachedView<H> {
        guard let cachedIndex: Int = self.firstIndex(where: {
            guard $0.isAvailable else {
                return false
            }
            return hash == $0.hash
        }) else {
            return nil
        }
        
        let cachedView: CachedView<H> = self[cachedIndex]
        self[cachedIndex].isAvailable = false
        
        return (NViewIndex(rawValue: cachedIndex), cachedView)
    }
    
//    @MainActor
//    internal func viewsCount<H>() -> Int
//    where Element == CachedView<H> {
//        var count: Int = 0
//        
//        for cached in self {
//            let views: [NView] = cached.views
//            count += views.viewsCount
//        }
//        
//        return count
//    }
    
    @MainActor
    internal func viewsCount<H>(upTo index: Int) -> StackIndex
    where Element == CachedView<H> {
        var count: StackIndex = 0
        
        for i in 0..<index {
            let cached: CachedView<H> = self[i]
            count += cached.viewsCount
        }
        
        return count
    }
    
    @MainActor
    internal mutating func getCached<H: Equatable>(hash: H?) -> (newIndex: NViewIndex, oldIndex: NViewIndex, view: CachedView<H>)?
    where Element == (oldIndex: NViewIndex, view: CachedView<H>) {
        guard let cachedIndex: Int = self.firstIndex(where: {
            guard $0.view.isAvailable else {
                return false
            }
            let oldHash = $0.view.hash
            return oldHash == hash
        }) else {
            return nil
        }
        
        let cachedView: (oldIndex: NViewIndex, view: CachedView<H>) = self[cachedIndex]
        self[cachedIndex].view.isAvailable = false
        
        return (NViewIndex(rawValue: cachedIndex), cachedView.oldIndex, cachedView.view)
    }
    
//    @MainActor
//    internal func viewsCount<H>(upTo index: NViewIndex) -> StackIndex
//    where Element == (oldIndex: NViewIndex, view: CachedView<H>) {
//        var count: StackIndex = 0
//        
//        for i in 0..<index.rawValue {
//            let cached: CachedView<H> = self[i].view
//            count += cached.viewsCount
//        }
//        
//        return count
//    }
}
