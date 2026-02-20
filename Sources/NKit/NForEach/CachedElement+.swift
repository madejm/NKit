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
        switch _element {
        case .array(let array):
            let mapped: [NView] = array.map { $0.view }
            return mapped
        case .object(let object):
            guard let value = object.value else {
                fatalError("Cached element was deallocated!")
            }
            return value
        case .nForEach(let nForEach):
            return nForEach.value
        case .nIf(let nIf):
            return nIf.value
        case .controlledView(let nControlledView):
            return nControlledView
        case .view(let view):
            guard let value = view.value else {
                fatalError("Cached element was deallocated!")
            }
            return value
        }
    }
    
    internal var viewsCount: Int {
        switch _element {
        case .array(let array):
            return array.reduce(into: 0) { $0 += $1.viewsCount }
        case .object(let object):
            if let value = object.value {
                return value.viewsCount
            } else {
                guard let lastWeakObjectViewCount = object.lastWeakObjectViewCount else {
                    fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
                }
                return lastWeakObjectViewCount
            }
        case .nForEach(let nForEach):
            return nForEach.value.viewsCount
        case .nIf(let nIf):
            return nIf.value.viewsCount
        case .controlledView(let nControlledView):
            return nControlledView.viewsCount
        case .view(let view):
            if let value = view.value {
                return value.viewsCount
            } else {
                guard let lastWeakObjectViewCount = view.lastWeakObjectViewCount else {
                    fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
                }
                return lastWeakObjectViewCount
            }
        }
    }
    
    internal var viewsCountInCache: Int {
        switch _element {
        case .array(let array):
            return array.reduce(into: 0) { $0 += $1.viewsCountInCache }
        case .object(let object):
            if let value = object.value {
                return value.viewsCountInCache
            } else {
                guard let lastWeakObjectViewCount = object.lastWeakObjectViewCount else {
                    fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
                }
                return lastWeakObjectViewCount
            }
        case .nForEach(let nForEach):
            return nForEach.value.viewsCountInCache
        case .nIf(let nIf):
            return nIf.value.viewsCountInCache
        case .controlledView(let nControlledView):
            return nControlledView.viewsCountInCache
        case .view(let view):
            if let value = view.value {
                return value.viewsCountInCache
            } else {
                guard let lastWeakObjectViewCount = view.lastWeakObjectViewCount else {
                    fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
                }
                return lastWeakObjectViewCount
            }
        }
    }
    
    internal func countViews(until end: AnyObject) -> (count: Int, stop: Bool) {
        switch _element {
        case .array(let array):
            var count: Int = 0
            
            for element in array {
                let result: (count: Int, stop: Bool) = element.countViews(until: end)
                count += result.count
                
                if result.stop {
                    return (count, true)
                }
            }
            
            return (count, false)
        case .object(let object):
            if let value = object.value {
                return value.countViews(until: end)
            } else {
                guard let lastWeakObjectViewCount = object.lastWeakObjectViewCount else {
                    fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
                }
                return (lastWeakObjectViewCount, false)
            }
        case .nForEach(let nForEach):
            return nForEach.value.countViews(until: end)
        case .nIf(let nIf):
            return nIf.value.countViews(until: end)
        case .controlledView(let nControlledView):
            return nControlledView.countViews(until: end)
        case .view(let view):
            if let value = view.value {
                return value.countViews(until: end)
            } else {
                guard let lastWeakObjectViewCount = view.lastWeakObjectViewCount else {
                    fatalError("Cached element was deallocated and lastObjectViewCount was not set!")
                }
                return (lastWeakObjectViewCount, false)
            }
        }
    }
}
