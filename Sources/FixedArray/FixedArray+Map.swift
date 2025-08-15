//
//  FixedArray+Map.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

extension FixedArray {
    public func map<T, E>(
        _ transform: (Element) throws(E) -> T
    ) throws(E) -> FixedArray<Size, T> where E: Error {
        let newArray: [T] = try self.array.map(transform)
        return .init(newArray)!
    }
}
