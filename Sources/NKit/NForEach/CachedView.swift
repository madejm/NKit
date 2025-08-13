//
//  CachedView.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

import AppKit

@MainActor
internal struct CachedView {
    internal var isAvailable: Bool = true
    internal let hash: Int
    internal let elements: [CachedElement]
    
    internal init(
        hash: Int,
        views: [NView]
    ) {
        self.hash = hash
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
}
