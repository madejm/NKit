//
//  CachedElement+Element.swift
//  NKit
//
//  Created by Mejdej on 21/02/2026.
//

extension CachedElement {
    
    @MainActor
    internal enum Element {
        case array([CachedElement])
        case object(Object)
        case nForEach(Dynamic<NForEach>)
        case nIf(Dynamic<NIf>)
        case controlledView(NControlledView)
        case view(View)
    }
}

extension CachedElement.Element {
    @MainActor
    final class Object {
        private(set) internal var lastWeakObjectViewCount: Int?
        private var isStrongified: Bool
        
        init(strongObject: (NView & AnyObject)) {
            self.strongObject = strongObject
            self.weakObject = nil
            self.lastWeakObjectViewCount = 1
            self.isStrongified = true
        }
        
        init(weakObject: (NView & AnyObject)) {
            self.strongObject = nil
            self.weakObject = weakObject
            self.lastWeakObjectViewCount = 1
            self.isStrongified = false
        }
        
        private var strongObject: (NView & AnyObject)?
        private weak var weakObject: (NView & AnyObject)? {
            willSet {
                guard let weakObject else {
                    return
                }
                if newValue == nil {
                    lastWeakObjectViewCount = weakObject.viewsCount
                }
            }
        }
        
        var value: (NView & AnyObject)? {
            if let strongObject {
                return strongObject
            }
            if let weakObject {
                return weakObject
            }
            return nil
        }
        
        func strongify() {
            guard !isStrongified else {
                fatalError("Trying to strongify an already strong element")
            }
            isStrongified = true
            strongObject = weakObject
            weakObject = nil
        }
        
        func weakify() {
            guard isStrongified else {
                fatalError("Trying to weakify an already weak element")
            }
            isStrongified = false
            weakObject = strongObject
            strongObject = nil
        }
        
        func clear() {
            weakObject = nil
            strongObject = nil
        }
    }
    
    @MainActor
    final class View {
        private(set) internal var lastWeakObjectViewCount: Int?
        private var isStrongified: Bool
        private var isCleared: Bool = false
        
        init(strongView: _View) {
            self.strongView = strongView
            self.weakView = nil
            self.lastWeakObjectViewCount = 1
            self.isStrongified = true
        }
        
        init(weakView: _View) {
            self.strongView = nil
            self.weakView = weakView
            self.lastWeakObjectViewCount = 1
            self.isStrongified = false
        }
        
        private var strongView: _View?
        private weak var weakView: _View? {
            willSet {
                guard let weakView else {
                    return
                }
                if newValue == nil {
                    lastWeakObjectViewCount = weakView.viewsCount
                }
            }
        }
        
        var value: _View? {
            if let strongView {
                return strongView
            }
            if let weakView {
                return weakView
            }
            return nil
        }
        
        func strongify() {
            guard !isStrongified else {
                return
            }
            guard let thisView = weakView else {
                fatalError("Trying to strongify nil")
            }
            isStrongified = true
            strongView = thisView
            weakView = nil
        }
        
        func weakify() {
            guard isStrongified else {
                return
            }
            guard let thisView = strongView else {
                fatalError("Trying to weakify nil")
            }
            isStrongified = false
            weakView = thisView
            strongView = nil
        }
        
        func clear() {
            isCleared = true
            weakView = nil
            strongView = nil
        }
    }
    
    @MainActor
    final class Dynamic<T: AnyObject & NCacheable> {
        private var element: any CachedElementDynamicStorage<T>
        private var isStrongified: Bool
        private var isCleared: Bool = false
        
        init(value: T, isStrongified: Bool) {
            self.element = D.storage(value)
            self.isStrongified = isStrongified
        }
        
        var value: T {
            guard let thisValue = element.value else {
                fatalError("Cached element was deallocated!")
            }
            return thisValue
        }
        
        func strongify() {
            guard !isStrongified else {
                return
//                fatalError("Trying to strongify an already strong element")
            }
            isStrongified = true
            value.strongify()
        }
        
        func weakify() {
            guard isStrongified else {
                return
//                fatalError("Trying to weakify an already weak element")
            }
            isStrongified = false
            value.weakify()
        }
        
        func clear() {
            isCleared = true
            element.value?.clear()
            element.value = nil
        }
    }
}
