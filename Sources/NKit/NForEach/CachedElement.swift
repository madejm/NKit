//
//  CachedView+CachedElement.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@MainActor
internal final class CachedElement {
    @MainActor
    internal enum Element {
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
//                    fatalError("Trying to strongify an already strong element")
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
//                    fatalError("Trying to weakify an already weak element")
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
        final class Weak<T: AnyObject & NCacheable> {
            private var strongValue: T?
            private weak var weakValue: T?
            private var isStrongified: Bool
            private var isCleared: Bool = false
            private let isRoot: Bool
            
            init(value: T, isStrongified: Bool, isRoot: Bool) {
                if isStrongified || isRoot {
                    self.strongValue = value
                    self.weakValue = nil
                } else {
                    self.strongValue = nil
                    self.weakValue = value
                }
                self.isRoot = isRoot
                self.isStrongified = isStrongified
            }
            
            var value: T {
                if isStrongified || isRoot {
                    guard let strongValue else {
                        fatalError("Cached element was deallocated!")
                    }
                    return strongValue
                } else {
                    guard let weakValue else {
                        fatalError("Cached element was deallocated!")
                    }
                    return weakValue
                }
            }
            
            func strongify() {
                guard !isStrongified else {
                    fatalError("Trying to strongify an already strong element")
                }
                isStrongified = true
                
                if isRoot {
                    guard let thisValue = strongValue else {
                        fatalError("Root is nil!")
                    }
                    thisValue.strongify()
                } else {
                    guard let thisValue = weakValue else {
                        fatalError("Trying to strongify nil")
                    }
                    thisValue.strongify()
                    strongValue = thisValue
                    weakValue = nil
                }
            }
            
            func weakify() {
                guard isStrongified else {
                    fatalError("Trying to weakify an already weak element")
                }
                isStrongified = false
                
                guard let thisValue = strongValue else {
                    fatalError("Trying to weakify nil")
                }
                thisValue.weakify()
                if !isRoot {
                    weakValue = thisValue
                    strongValue = nil
                }
            }
            
            func clear() {
                isCleared = true
                weakValue?.clear()
                strongValue?.clear()
                weakValue = nil
                strongValue = nil
            }
        }
        
        case array([CachedElement])
        case object(Object)
        case nForEach(Weak<NForEach>)
        case nIf(Weak<NIf>)
        case controlledView(NControlledView)
        case view(View)
    }
    
    #if DEBUG
    nonisolated
    private let DEBUG_TEXT: String
    #endif
    private var isStrongified: Bool
    private(set) internal var _element: Element
    
    internal var element: (any NView)? {
        switch _element {
        case .array(let array):
            array.compactMap(\.element)
        case .object(let object):
            object.value
        case .nForEach(let nForEach):
            nForEach.value
        case .nIf(let nIf):
            nIf.value
        case .controlledView(let nControlledView):
            nControlledView
        case .view(let view):
            view.value
        }
    }
    
    internal init(
        view: NView,
        isStrongified: Bool,
        isRoot: Bool
    ) {
        self.isStrongified = isStrongified
        
        switch view.unpacked {
        case .controlledView(let controlledView):
            #if DEBUG
            self.DEBUG_TEXT = "CONTROLLED VIEW [\(String(describing: type(of: controlledView)))]"
            #endif
            self._element = .controlledView(controlledView)
        case .array(let array):
            #if DEBUG
            self.DEBUG_TEXT = "ARRAY [\(String(describing: type(of: array)))]"
            #endif
            self._element = .array(array.map {
                CachedElement(view: $0, isStrongified: isStrongified, isRoot: isRoot)
            })
        case .view(let view):
            #if DEBUG
            let textValue: String? = ((view as? Text)?.debugStringValue).map { " (\($0))"}
            self.DEBUG_TEXT = "_VIEW [\(String(describing: type(of: view)))\(textValue ?? "")]"
            #endif
            if isStrongified {
                self._element = .view(.init(strongView: view))
            } else {
                self._element = .view(.init(weakView: view))
            }
        case .forEach(let nForEach):
            #if DEBUG
            self.DEBUG_TEXT = "NForEach [\(nForEach.describeTypeOfData)]"
            #endif
            self._element = .nForEach(.init(
                value: nForEach,
                isStrongified: isStrongified,
                isRoot: isRoot
            ))
        case .if(let nIf):
            #if DEBUG
            self.DEBUG_TEXT = "NIf"
            #endif
            self._element = .nIf(.init(
                value: nIf,
                isStrongified: isStrongified,
                isRoot: isRoot
            ))
        case .otherObject(let object):
            #if DEBUG
            self.DEBUG_TEXT = "OTHER OBJECT [\(String(describing: type(of: object)))]"
            #endif
            if isStrongified {
                self._element = .object(.init(strongObject: object))
            } else {
                self._element = .object(.init(weakObject: object))
            }
        case .other(let nView):
            fatalError("Trying to cache non object value: \(String(describing: type(of: nView)))!")
        }
    }
    
    deinit {
        #if DEBUG
        print_debug("💥 DEINIT CachedElement \(DEBUG_TEXT)")
        #endif
    }
    
    internal func strongify() {
//        guard !isStrongified else {
//            fatalError("Trying to strongify an already strong cache")
//            return
//        }
        self.isStrongified = true
        
        switch _element {
        case .array(let array):
            for element in array {
                element.strongify()
            }
        case .object(let object):
            object.strongify()
        case .nForEach(let nForEach):
            nForEach.strongify()
        case .nIf(let nIf):
            nIf.strongify()
        case .controlledView:
            break
        case .view(let view):
            view.strongify()
        }
    }
    
    internal func weakify() {
//        guard isStrongified else {
//            fatalError("Trying to weakify an already weak cache")
//        }
        self.isStrongified = false
        
        switch _element {
        case .array(let array):
            for element in array {
                element.weakify()
            }
        case .object(let object):
            object.weakify()
        case .nForEach(let nForEach):
            nForEach.weakify()
        case .nIf(let nIf):
            nIf.weakify()
        case .controlledView:
            break
        case .view(let view):
            view.weakify()
        }
    }
    
    internal func clear() {
        switch _element {
        case .array(let array):
            for element in array {
                element.clear()
            }
        case .object(let object):
            object.clear()
        case .nForEach(let nForEach):
            nForEach.clear()
        case .nIf(let nIf):
            nIf.clear()
        case .controlledView:
            break
        case .view(let view):
            view.clear()
        }
    }
}
