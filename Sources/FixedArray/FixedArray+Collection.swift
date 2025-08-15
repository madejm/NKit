//
//  FixedArray+Collection.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

extension FixedArray: Sequence {
}

extension FixedArray: Collection {
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

extension FixedArray: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        self.array.index(before: i)
    }
    
    public func formIndex(before i: inout Index) {
        self.array.formIndex(before: &i)
    }
}

extension FixedArray: RandomAccessCollection {
}
