//
//  CachedView+.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

extension CachedView {
    internal var views: [NView] {
        self.elements.map {
            $0.view
        }
    }
    
    internal var viewsCount: Int {
        self.elements.reduce(into: 0) {
            $0 += $1.viewsCount
        }
    }
    
    internal var viewsCountInCache: Int {
        self.elements.reduce(into: 0) {
            $0 += $1.viewsCountInCache
        }
    }
    
    internal func countViews(until end: NForEach) -> (count: Int, stop: Bool) {
        var count: Int = 0
        
        for element in elements {
            let result: (count: Int, stop: Bool) = element.countViews(until: end)
            count += result.count
            
            if result.stop {
                return (count, true)
            }
        }
        
        return (count, false)
    }
}
