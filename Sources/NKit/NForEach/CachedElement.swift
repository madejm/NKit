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
    private(set) internal var strongObject: (NView & AnyObject)?
    private(set) internal /*weak*/ var weakObject: _View? {
        willSet {
            guard let weakObject else {
                return
            }
            if newValue == nil {
                lastWeakObjectViewCount = weakObject.viewsCount
            }
        }
    }
    
    internal init(view: NView) {
        if let array = view as? [NView] {
            self.DEBUG_TEXT = "ARRAY"
            self.array = array.map {
                CachedElement(view: $0)
            }
        } else if let object = view as? _View {
            self.DEBUG_TEXT = "_VIEW"
            self.weakObject = object
            self.lastWeakObjectViewCount = 1
        } else if let object = view as? (NView & AnyNForEach) {
            self.DEBUG_TEXT = "AnyNForEach"
            self.strongObject = object
        } else if let object = view as? (NView & AnyObject) {
            self.DEBUG_TEXT = "another"
            self.strongObject = object
        } else {
            fatalError("Trying to cache non object value: \(String(describing: type(of: view)))!")
        }
    }
    
    deinit {
        print_debug("✨ DEINIT CachedElement \(DEBUG_TEXT)")
    }
    
    internal func clear() {
        if let array {
            for element in array {
                element.clear()
            }
        }
        if let object = strongObject ?? weakObject {
            if let anyNForEach = object as? AnyNForEach {
                anyNForEach.clearCache()
            }
            self.strongObject = nil
            self.weakObject = nil
        }
    }
}
