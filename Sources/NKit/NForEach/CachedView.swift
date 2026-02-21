//
//  CachedView.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

@MainActor
internal struct CachedView<H> {
    internal var isAvailable: Bool = true
    internal let hash: H
    internal let elements: [CachedElement<CachedElementDynamicStrong>]
    
    internal init(
        hash: H,
        views: [NView],
        isStrongified: Bool
    ) {
        self.hash = hash
        self.elements = views.map {
            CachedElement(
                view: $0,
                isStrongified: isStrongified
            )
        }
    }
    
    internal mutating func clear() {
        self.isAvailable = false
        
        for element in elements {
            element.clear()
        }
    }
    
    internal func strongify() {
        for element in elements {
            element.strongify()
        }
    }
    
    internal func weakify() {
        for element in elements {
            element.weakify()
        }
    }
}
