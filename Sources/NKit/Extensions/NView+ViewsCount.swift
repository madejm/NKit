//
//  NView+.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

extension Array where Element == NView {
    @MainActor
    internal func arrayViewsCount() -> Int {
        self.reduce(into: 0) {
            $0 += $1.viewsCount
        }
    }
    
    @MainActor
    internal var arrayViewsCountInCache: Int {
        self.reduce(into: 0) {
            $0 += $1.viewsCountInCache
        }
    }
    
//    @MainActor
//    internal func viewCount(upTo index: Int) -> Int {
//        guard index > 0 else {
//            return 0
//        }
//        
//        var sum: Int = 0
//        
//        for i in 0..<index {
//            let view: NView = self[i]
//            sum += view.viewsCount
//        }
//        
//        return sum
//    }
}
