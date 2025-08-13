//
//  DeallocationChecker.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

import AppKit
@testable import NKit

final class DeallocationChecker {
    
    private var elements: [WeakElement] = []
    private(set) var deallocatedCount: Int = 0
    
    init() {
    }
    
    @MainActor
    func append(_ newElement: NSView) {
        elements.append(WeakElement(
            element: newElement,
            deallocated: { [unowned self] in
                self.deallocatedCount += 1
            }
        ))
    }
    
    var elementsCount: Int {
        elements.count
    }
    
    @MainActor
    var notDeallocated: [Any] {
        elements.compactMap {
            $0.element?.mirrorDescription
        }
    }
}

extension DeallocationChecker {
    @MainActor
    final class WeakElement: @MainActor CustomReflectable {
        
        private var deallocated: () -> Void
        
        private(set) weak var element: NSView? {
            willSet {
                guard newValue == nil else {
                    return
                }
                deallocated()
            }
        }
        
        init(
            element: NSView,
            deallocated: @escaping () -> Void
        ) {
            self.element = element
            self.deallocated = deallocated
        }
        
        public var customMirror: Mirror {
            if let tf = element as? NSTextField {
                return Mirror(self, children: ["stringValue": tf.stringValue])
            } else {
                return Mirror(reflecting: element as Any)
            }
        }
    }
}
