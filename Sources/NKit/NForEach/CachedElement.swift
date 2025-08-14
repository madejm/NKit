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
    private(set) internal var nForEach: (NView & NForEach)?
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
    
    internal init(
        view: NView,
        isStrongified: Bool
    ) {
        if let array = view as? [NView] {
            self.DEBUG_TEXT = "ARRAY"
            self.array = array.map {
                CachedElement(view: $0, isStrongified: isStrongified)
            }
        } else if let object = view as? _View {
            self.DEBUG_TEXT = "_VIEW"
            if isStrongified {
                self.strongView = object
            } else {
                self.weakView = object
            }
            self.lastWeakObjectViewCount = 1
        } else if let object = view as? NForEach {
            self.DEBUG_TEXT = "NForEach"
            self.nForEach = object
        } else if let object = view as? (NView & AnyObject) {
            self.DEBUG_TEXT = "another"
            self.object = object
        } else {
            fatalError("Trying to cache non object value: \(String(describing: type(of: view)))!")
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
