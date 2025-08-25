//
//  elementHash.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@MainActor
internal func elementHash<C>(_ element: NGet<C>) -> Int? where C: Hashable {
    let unwrapped: C? = element.wrappedValue
    
    guard let value: AnyHashable = unwrapped else {
        return nil
    }
    
    let hash = value.hashValue
    return hash
}
