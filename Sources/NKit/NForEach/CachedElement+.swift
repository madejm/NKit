//
//  CachedElement+.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

extension CachedElement {
//    internal var objectStringValue: String {
//        if let array {
//            return "[ " + array.map { $0.objectStringValue }.joined(separator: " ") + " ]"
//        }
//        if let strongObject {
//            return "< " + ((strongObject as? Text)?.stringValue ?? "nil") + " >"
//        }
//        if let weakObject {
//            return "{ " + ((weakObject as? Text)?.stringValue ?? "nil") + " }"
//        }
//        if let lastWeakObjectViewCount {
//            return "(count: \(lastWeakObjectViewCount))"
//        }
//        return "XXX"
//    }
}

extension CachedElement {
    internal var view: NView {
        if let array {
            let mapped: [NView] = array.map { $0.view }
            return mapped
        }
        if let object {
            return object
        }
        if let nForEach {
            return nForEach
        }
        if let strongView {
            return strongView
        }
        if let weakView {
            return weakView
        }
        fatalError("Cached element was deallocated!")
    }
    
    internal var viewsCount: Int {
        if let array {
            return array.reduce(into: 0) { $0 += $1.viewsCount }
        }
        if let object {
            return object.viewsCount
        }
        if let nForEach {
            return nForEach.viewsCount
        }
        if let strongView {
            return strongView.viewsCount
        }
        if let weakView {
            return weakView.viewsCount
        }
        if let lastWeakObjectViewCount {
            return lastWeakObjectViewCount
        }
        fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
    }
    
    internal var viewsCountInCache: Int {
        if let array {
            return array.reduce(into: 0) { $0 += $1.viewsCountInCache }
        }
        if let object {
            return object.viewsCountInCache
        }
        if let nForEach {
            return nForEach.viewsCountInCache
        }
        if let strongView {
            return strongView.viewsCountInCache
        }
        if let weakView {
            return weakView.viewsCountInCache
        }
        if let lastWeakObjectViewCount {
            return lastWeakObjectViewCount
        }
        fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
    }
    
    internal func countViews(until end: AnyObject) -> (count: Int, stop: Bool) {
        if let array {
            var count: Int = 0
            
            for element in array {
                let result: (count: Int, stop: Bool) = element.countViews(until: end)
                count += result.count
                
                if result.stop {
                    return (count, true)
                }
            }
            
            return (count, false)
        }
        if let object {
            return object.countViews(until: end)
        }
        if let nForEach {
            return nForEach.countViews(until: end)
        }
        if let strongView {
            return strongView.countViews(until: end)
        }
        if let weakView {
            return weakView.countViews(until: end)
        }
        if let lastWeakObjectViewCount {
            return (lastWeakObjectViewCount, false)
        }
        fatalError("Cannot count views, object was dellocated!")
    }
    
}
