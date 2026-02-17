//
//  View+Tag.swift
//  NKit
//
//  Created by Mejdej on 17/02/2026.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    public func tag<Tag>(_ value: Tag) -> Self {
        self[associatedId: .tag] = value
        return self
    }
    
    public func hasTag<Tag: Equatable>(_ value: Tag) -> Bool {
        let currentTag: Tag? = self[associatedId: .tag]
        return value == currentTag
    }
}
