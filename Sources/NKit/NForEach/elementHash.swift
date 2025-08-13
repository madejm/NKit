//
//  elementHash.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@MainActor
internal func elementHash(_ element: Any) -> Int? {
    guard let nAnyGet = element as? any NAnyGet else {
        return nil
    }
    guard let optional: AnyHashable? = nAnyGet.wrappedValue as? AnyHashable? else {
        return nil
    }
    guard let value: AnyHashable = optional else {
        return nil
    }
    
    let hash = value.hashValue
    return hash
}
