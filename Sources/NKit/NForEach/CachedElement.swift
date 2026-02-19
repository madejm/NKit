//
//  CachedView+CachedElement.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@MainActor
internal final class CachedElement {
    internal let DEBUG_TEXT: String
    private(set) internal var lastWeakObjectViewCount: Int?
    
    private(set) internal var array: [CachedElement]?
    private(set) internal var object: (NView & AnyObject)?
    private(set) internal var nForEach: NForEach?
    private(set) internal var nIf: NIf?
    private(set) internal var controlledView: NControlledView?
    private(set) internal var strongView: _View?
    private(set) internal /*weak*/ var weakView: _View? {
        willSet {
            guard let weakView else {
                return
            }
            if newValue == nil {
                lastWeakObjectViewCount = weakView.viewsCount
            }
        }
    }
    
    internal var element: (any NView)? {
        array?.compactMap(\.element) ??
        object ??
        nForEach ??
        strongView ??
        weakView
    }
    
    internal init(
        view: NView,
        isStrongified: Bool
    ) {
        switch view.unpacked {
        case .controlledView(let controlledView):
            self.DEBUG_TEXT = "CONTROLLED VIEW"
            self.controlledView = controlledView
        case .array(let array):
            self.DEBUG_TEXT = "ARRAY"
            self.array = array.map {
                CachedElement(view: $0, isStrongified: isStrongified)
            }
        case .view(let view):
            self.DEBUG_TEXT = "_VIEW"
            if isStrongified {
                self.strongView = view
            } else {
                self.weakView = view
            }
            self.lastWeakObjectViewCount = 1
        case .forEach(let nForEach):
            self.DEBUG_TEXT = "NForEach"
            self.nForEach = nForEach
        case .if(let nIf):
            self.DEBUG_TEXT = "NIf"
            self.nIf = nIf
        case .otherObject(let object):
            self.DEBUG_TEXT = "another"
            self.object = object
        case .other(let nView):
            fatalError("Trying to cache non object value: \(String(describing: type(of: nView)))!")
        }
    }
    
    deinit {
        print_debug("💥 DEINIT CachedElement \(DEBUG_TEXT)")
    }
    
    internal func strongify() {
        if let array {
            for element in array {
                element.strongify()
            }
        }
        if let nForEach {
            nForEach.strongifyCache()
        }
        if let weakView {
            self.weakView = nil
            self.strongView = weakView
        }
    }
    
    internal func weakify() {
        if let array {
            for element in array {
                element.weakify()
            }
        }
        if let nForEach {
            nForEach.weakifyCache()
        }
        if let strongView {
            self.strongView = nil
            self.weakView = strongView
        }
    }
    
    internal func clear() {
        if let array {
            for element in array {
                element.clear()
            }
        }
        if let nForEach {
            nForEach.clearCache()
        }
        if object != nil {
            self.object = nil
        }
        if strongView != nil {
            self.strongView = nil
        }
        if weakView != nil {
            self.weakView = nil
        }
    }
}
