//
//  CachedView.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

@MainActor
internal struct CachedView {
    internal var isAvailable: Bool = true
    internal let hash: Int
//    var viewOffset: StackIndex
//    var viewsCount: Int
    private let elements: [CachedElement]
    
    internal init(
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
    
    internal mutating func clear() {
        self.isAvailable = false
        
        for element in elements {
            element.clear()
        }
    }
    
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
    
    internal func countViews(until end: AnyNForEach) -> (count: Int, stop: Bool) {
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

extension CachedView {
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
        
        func countViews(until end: AnyNForEach) -> (count: Int, stop: Bool) {
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
            if let lastObjectViewCount {
                return (lastObjectViewCount, false)
            }
            fatalError("Nah...")
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
    
}
