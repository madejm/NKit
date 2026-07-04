//
//  DeallocationChecker.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@testable import NKit
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class DeallocationChecker {
    
    private var elements: [WeakElement] = []
    
    init() {
    }
    
    @MainActor
    func append(_ newElement: AnyObject) {
        elements.append(WeakElement(
            element: newElement
        ))
    }
    
    var elementsCount: Int {
        elements.count
    }
    
    @MainActor
    func cleanup() {
        elements.removeAll(where: { $0.element == nil })
    }
    
    @MainActor
    func getDeallocatedCount() async -> Int {
        try? await Task.sleep(nanoseconds: 1_000_000)
        
        return elements.count(where: { $0.element == nil })
    }
    
    @MainActor
    func getNotDeallocated() async -> [Any] {
        try? await Task.sleep(nanoseconds: 1_000_000)
        
        return elements.compactMap {
            guard let element = $0.element else {
                return nil
            }
            if let view = element as? _View {
                return view.mirrorDescription
            } else {
                return String(describing: element)
            }
        }
    }
}

extension DeallocationChecker {
    @MainActor
    final class WeakElement {
        
        private(set) weak var element: AnyObject?
        
        init(
            element: AnyObject
        ) {
            self.element = element
        }
        
        fileprivate var _customMirror: Mirror {
            if let tf = element as? NText {
                #if canImport(AppKit)
                return Mirror(self, children: ["stringValue": tf.stringValue])
                #elseif canImport(UIKit)
                return Mirror(self, children: ["stringValue": tf.text as Any])
                #endif
            } else {
                return Mirror(reflecting: element as Any)
            }
        }
    }
}

#if swift(>=6.1)
extension DeallocationChecker.WeakElement: @MainActor CustomReflectable {
    public var customMirror: Mirror {
        _customMirror
    }
}
#else
extension DeallocationChecker.WeakElement: @preconcurrency CustomReflectable {
    public var customMirror: Mirror {
        _customMirror
    }
}
#endif

extension NForEach {
    func checkDealloc(in deallocationChecker: DeallocationChecker) -> Self {
        deallocationChecker.append(self)
        return self
    }
}

extension NIf {
    func checkDealloc(in deallocationChecker: DeallocationChecker) -> Self {
        deallocationChecker.append(self)
        return self
    }
}
