//
//  ConstantSizeArray.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

public struct ConstantSizeArray<Element> {
    private var array: Array<Element>
    
    public init?(_ array: Array<Element>) {
        guard !array.isEmpty else {
            return nil
        }
        self.array = array
    }
    
    public init?<S>(_ elements: S) where S: Sequence, Element == S.Element {
        let array = Array(elements)
        
        guard !array.isEmpty else {
            return nil
        }
        self.array = array
    }
    
    public init?(
        repeating repeatedValue: Element,
        count: Int
    ) {
        guard count > 0 else {
            return nil
        }
        self.array = Array(repeating: repeatedValue, count: count)
    }
}

extension ConstantSizeArray {
    public var isEmpty: Bool {
        self.array.isEmpty
    }
    
    public var count: Int {
        self.array.count
    }
}

extension ConstantSizeArray {
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
            guard array.startIndex <= bounds.lowerBound, array.endIndex > bounds.upperBound else {
                return nil
            }
            return array[bounds]
        }
        set {
            guard array.startIndex <= bounds.lowerBound, array.endIndex > bounds.upperBound else {
                return
            }
            guard let newValue else {
                return
            }
            array[bounds] = newValue
        }
    }
}

extension ConstantSizeArray {
    public mutating func replaceSubrange<C>(
        _ subrange: Range<Int>,
        with newElements: C
    ) where Element == C.Element, C : Collection {
        guard array.startIndex <= subrange.lowerBound, array.endIndex > subrange.upperBound else {
            return
        }
        array.replaceSubrange(subrange, with: newElements)
    }
}

extension ConstantSizeArray {
//    public static func + <Other>(lhs: Other, rhs: Self) -> Self where Other: Sequence, Element == Other.Element {
//        
//    }
//    
//    public static func + <Other>(lhs: Self, rhs: Other) -> Self where Other: Sequence, Element == Other.Element {
//        
//    }
//    
//    public static func + (lhs: Self, rhs: Self) -> Self {
//        
//    }
}

extension ConstantSizeArray {
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

//extension ConstantSizeArray {
//    func prefix(Int) -> Self.SubSequence
//    func prefix(through: Self.Index) -> Self.SubSequence
//    func prefix(upTo: Self.Index) -> Self.SubSequence
//    func prefix(while: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence
//    func suffix(Int) -> Self.SubSequence
//    func suffix(from: Self.Index) -> Self.SubSequence
//}
//
//extension ConstantSizeArray {
//    func dropFirst(Int) -> Self.SubSequence
//    func dropLast(Int) -> Self.SubSequence
//    func drop(while: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence
//}
//
//extension ConstantSizeArray {
//    func flatMap<SegmentOfResult>((Self.Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element]
//    func flatMap<ElementOfResult>((Self.Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
//    func compactMap<ElementOfResult>((Self.Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
//    func reduce<Result>(Result, (Result, Self.Element) throws -> Result) rethrows -> Result
//    func reduce<Result>(into: Result, (inout Result, Self.Element) throws -> ()) rethrows -> Result
//    var lazy: LazySequence<Self>
//
//}
//
//extension ConstantSizeArray {
//    func forEach((Self.Element) throws -> Void) rethrows
//    func enumerated() -> EnumeratedSequence<Self>
//    func makeIterator() -> IndexingIterator<Self>
//    var underestimatedCount: Int
//}
//
//extension ConstantSizeArray {
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
//extension ConstantSizeArray {
//    func split(separator: Self.Element, maxSplits: Int, omittingEmptySubsequences: Bool) -> [Self.SubSequence]
//    func split(maxSplits: Int, omittingEmptySubsequences: Bool, whereSeparator: (Self.Element) throws -> Bool) rethrows -> [Self.SubSequence]
//    func joined() -> FlattenSequence<Self>
//    func joined<Separator>(separator: Separator) -> JoinedSequence<Self>
//    func joined(separator: String) -> String
//    func joined(separator: String) -> String
//
//}
//
//extension ConstantSizeArray {
//    func applying(CollectionDifference<Self.Element>) -> Self?
//    func difference<C>(from: C) -> CollectionDifference<Self.Element>
//    func difference<C>(from: C, by: (C.Element, Self.Element) -> Bool) -> CollectionDifference<Self.Element>
//}
//
//extension ConstantSizeArray {
//}


extension ConstantSizeArray: Equatable where Element: Equatable {
}

extension ConstantSizeArray: Hashable where Element: Hashable {
    public func hash(into hasher: inout Hasher) {
        array.hash(into: &hasher)
    }
}

extension ConstantSizeArray: Encodable where Element: Encodable {
    public func encode(to encoder: any Encoder) throws {
        try array.encode(to: encoder)
    }
}

extension ConstantSizeArray: Decodable where Element: Decodable {
    public init(from decoder: any Decoder) throws {
        let array: Array<Element> = try .init(from: decoder)
        self.init(array)!
    }
}

extension ConstantSizeArray: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)!
    }
}

extension ConstantSizeArray: Sequence {
}

extension ConstantSizeArray: Collection {
    public typealias Index = Int
    
    public var startIndex: Index {
        self.array.startIndex
    }
    
    public var endIndex: Index {
        self.array.endIndex
    }
    
    public var indices: Indices {
        self.array.indices
    }
    
    public func index(after i: Index) -> Index {
        self.array.index(after: i)
    }
    
    public func formIndex(after i: inout Index) {
        self.array.formIndex(after: &i)
    }
    
    public subscript(position: Index) -> Element {
        self.array[position]
    }
}

extension ConstantSizeArray: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        self.array.index(before: i)
    }
    
    public func formIndex(before i: inout Index) {
        self.array.formIndex(before: &i)
    }
}

extension ConstantSizeArray: RandomAccessCollection {
}
