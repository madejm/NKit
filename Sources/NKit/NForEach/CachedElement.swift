//
//  CachedView+CachedElement.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@MainActor
internal final class CachedElement<D: CachedElementDynamicStrategy> {
    
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
        case .other(let nView):
            nView
        case .view(let view):
            view.value
        }
    }
    
    internal init(
        view: NView,
        isStrongified: Bool
    ) {
        self.isStrongified = isStrongified
        
        switch view.unpacked {
        case .array(let array):
            #if DEBUG
            self.DEBUG_TEXT = "ARRAY [\(String(describing: type(of: array)))]"
            #endif
            self._element = .array(array.map {
                CachedElement(view: $0, isStrongified: isStrongified)
            })
        case .view(let view):
            #if DEBUG
            let textValue: String? = ((view as? NText)?.debugStringValue).map { " (\($0))"}
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
                isStrongified: isStrongified
            ))
        case .if(let nIf):
            #if DEBUG
            self.DEBUG_TEXT = "NIf"
            #endif
            self._element = .nIf(.init(
                value: nIf,
                isStrongified: isStrongified
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
            #if DEBUG
            self.DEBUG_TEXT = "OTHER [\(String(describing: type(of: nView)))]"
            #endif
            self._element = .other(nView)
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
        case .other:
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
        case .other:
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
        case .other:
            break
        case .view(let view):
            view.clear()
        }
    }
}
