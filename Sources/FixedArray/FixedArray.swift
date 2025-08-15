//
//  FixedArray.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

public struct FixedArray<Size: FixedArraySize, Element> {
    internal var array: Array<Element>
    
    public init?<S>(_ elements: S) where S: Sequence, Element == S.Element {
        let array = Array(elements)
        
        guard array.count == Size.count else {
            return nil
        }
        self.array = array
    }
    
    public init(
        repeating repeatedValue: Element
    ) {
        self.array = Array(repeating: repeatedValue, count: Size.count)
    }
    
//    public init?(
//        _ elements: Element...
//    ) {
//        let array = Array(elements)
//        
//        guard array.count == Size.count else {
//            return nil
//        }
//        self.array = array
//    }
    
//    public init(
//        _ first: Element, _ elements: Element...
//    ) {
//        self.array = [first] + Array(elements)
//    }
}

extension FixedArray {
    public var isEmpty: Bool {
        self.array.isEmpty
    }
    
    public var count: Int {
        self.array.count
    }
}

extension FixedArray {
    public subscript(index: Int) -> Element? {
        get {
            guard array.indices.contains(index) else {
                return nil
            }
            return array[index]
        }
        set {
            guard array.indices.contains(index) else {
                return
            }
            guard let newValue else {
                return
            }
            array[index] = newValue
        }
    }
    
    public var first: Element {
        self.array.first!
    }
    
    public var last: Element {
        self.array.last!
    }
    
    public subscript(bounds: Range<Int>) -> ArraySlice<Element>? {
        get {
            guard array.startIndex <= bounds.lowerBound, array.endIndex >= bounds.upperBound else {
                return nil
            }
            return array[bounds]
        }
        set {
            guard array.startIndex <= bounds.lowerBound, array.endIndex >= bounds.upperBound else {
                return
            }
            guard let newValue else {
                return
            }
            guard array[bounds].count == newValue.count else {
                return
            }
            array[bounds] = newValue
        }
    }
}

extension FixedArray {
    public mutating func replaceSubrange<C>(
        _ subrange: Range<Int>,
        with newElements: C
    ) where Element == C.Element, C : Collection {
        guard array.startIndex <= subrange.lowerBound, array.endIndex >= subrange.upperBound else {
            return
        }
        guard array[subrange].count == newElements.count else {
            return
        }
        array.replaceSubrange(subrange, with: newElements)
    }
}

extension FixedArray {
    public func contains(_ element: Element) -> Bool where Element: Equatable {
        array.contains(element)
    }
    
    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        try array.contains(where: predicate)
    }
    
    public func allSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        try array.allSatisfy(predicate)
    }
    
    public func first(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        try array.first(where: predicate)
    }
    
    public func firstIndex(of element: Element) -> Index? where Element: Equatable {
        array.firstIndex(of: element)
    }
    
    public func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Index? {
        try array.firstIndex(where: predicate)
    }
    
    public func last(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        try array.last(where: predicate)
    }
    
    public func lastIndex(of element: Element) -> Index? where Element: Equatable {
        array.lastIndex(of: element)
    }
    
    public func lastIndex(where predicate: (Element) throws -> Bool) rethrows -> Index? {
        try array.lastIndex(where: predicate)
    }
}

//extension FixedArray {
//    func prefix(Int) -> Self.SubSequence
//    func prefix(through: Self.Index) -> Self.SubSequence
//    func prefix(upTo: Self.Index) -> Self.SubSequence
//    func prefix(while: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence
//    func suffix(Int) -> Self.SubSequence
//    func suffix(from: Self.Index) -> Self.SubSequence
//}
//
//extension FixedArray {
//    func dropFirst(Int) -> Self.SubSequence
//    func dropLast(Int) -> Self.SubSequence
//    func drop(while: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence
//}
//
//extension FixedArray {
//    func flatMap<SegmentOfResult>((Self.Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element]
//    func flatMap<ElementOfResult>((Self.Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
//    func compactMap<ElementOfResult>((Self.Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
//    func reduce<Result>(Result, (Result, Self.Element) throws -> Result) rethrows -> Result
//    func reduce<Result>(into: Result, (inout Result, Self.Element) throws -> ()) rethrows -> Result
//    var lazy: LazySequence<Self>
//
//}
//
//extension FixedArray {
//    func forEach((Self.Element) throws -> Void) rethrows
//    func enumerated() -> EnumeratedSequence<Self>
//    func makeIterator() -> IndexingIterator<Self>
//    var underestimatedCount: Int
//}
//
//extension FixedArray {
//    func sort()
//    func sort(by: (Self.Element, Self.Element) throws -> Bool) rethrows
//    func sorted() -> [Self.Element]
//    func sorted(by: (Self.Element, Self.Element) throws -> Bool) rethrows -> [Self.Element]
//    func reverse()
//    func reversed() -> ReversedCollection<Self>
//    func shuffle()
//    func shuffle<T>(using: inout T)
//    func shuffled() -> [Self.Element]
//    func shuffled<T>(using: inout T) -> [Self.Element]
//    func partition(by: (Self.Element) throws -> Bool) rethrows -> Self.Index
//    func swapAt(Self.Index, Self.Index)
//}
//
//extension FixedArray {
//    func split(separator: Self.Element, maxSplits: Int, omittingEmptySubsequences: Bool) -> [Self.SubSequence]
//    func split(maxSplits: Int, omittingEmptySubsequences: Bool, whereSeparator: (Self.Element) throws -> Bool) rethrows -> [Self.SubSequence]
//    func joined() -> FlattenSequence<Self>
//    func joined<Separator>(separator: Separator) -> JoinedSequence<Self>
//    func joined(separator: String) -> String
//    func joined(separator: String) -> String
//
//}
//
//extension FixedArray {
//    func applying(CollectionDifference<Self.Element>) -> Self?
//    func difference<C>(from: C) -> CollectionDifference<Self.Element>
//    func difference<C>(from: C, by: (C.Element, Self.Element) -> Bool) -> CollectionDifference<Self.Element>
//}
