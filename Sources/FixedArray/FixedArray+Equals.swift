//
//  FixedArray+Operators.swift
//  NKit
//
//  Created by Mejdej on 15/08/2025.
//

public func == <Size, Element, C>(lhs: FixedArray<Size, Element>?, rhs: C) -> Bool
where C: Collection, C.Element == Element, Element: Equatable {
    if let array = rhs as? Array<Element> {
        return lhs?.array == array
    }
    return lhs?.array == Array(rhs)
}

public func != <Size, Element, C>(lhs: FixedArray<Size, Element>?, rhs: C) -> Bool
where C: Collection, C.Element == Element, Element: Equatable {
    if let array = rhs as? Array<Element> {
        return lhs?.array != array
    }
    return lhs?.array != Array(rhs)
}

public func == <Size, Element, C>(lhs: C, rhs: FixedArray<Size, Element>?) -> Bool
where C: Collection, C.Element == Element, Element: Equatable {
    if let array = lhs as? Array<Element> {
        return array == rhs?.array
    }
    return Array(lhs) == rhs?.array
}

public func != <Size, Element, C>(lhs: C, rhs: FixedArray<Size, Element>?) -> Bool
where C: Collection, C.Element == Element, Element: Equatable {
    if let array = lhs as? Array<Element> {
        return array != rhs?.array
    }
    return Array(lhs) != rhs?.array
}

public func == <SizeL, SizeR, Element>(lhs: FixedArray<SizeL, Element>, rhs: FixedArray<SizeR, Element>) -> Bool
where Element: Equatable {
    guard SizeL.count == SizeR.count else {
        return false
    }
    guard lhs.array == rhs.array else {
        return false
    }
    return true
}

public func != <SizeL, SizeR, Element>(lhs: FixedArray<SizeL, Element>, rhs: FixedArray<SizeR, Element>) -> Bool
where Element: Equatable {
    if SizeL.count != SizeR.count {
        return true
    }
    if lhs.array != rhs.array {
        return true
    }
    return false
}
