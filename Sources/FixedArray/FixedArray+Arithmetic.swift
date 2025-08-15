//
//  FixedArray+Arithmetic.swift
//  NKit
//
//  Created by Mejdej on 15/08/2025.
//

public func + <SizeL, SizeR, SizeT, Element>(
    lhs: FixedArray<SizeL, Element>,
    rhs: FixedArray<SizeR, Element>
) -> FixedArray<SizeT, Element>? {
    let array: [Element] = lhs.array + rhs.array
    return .init(array)
}
