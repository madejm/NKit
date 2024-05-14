import Foundation

extension NGet: Sequence where Value: MutableCollection, Value.Element: Equatable {
    public typealias Element = NGet<Value.Element?>
    public typealias Iterator = IndexingIterator<NGet<Value>>
    public typealias SubSequence = Slice<NGet<Value>>
}

extension NGet: Collection where Value: MutableCollection, Value.Element: Equatable {
    public typealias Index = Value.Index
    public typealias Indices = Value.Indices
    
    public var startIndex: NGet<Value>.Index {
        self.wrappedValue.startIndex
    }
    
    public var endIndex: NGet<Value>.Index {
        self.wrappedValue.endIndex
    }
    
    public var indices: Value.Indices {
        self.wrappedValue.indices
    }
    
    public func index(after i: NGet<Value>.Index) -> NGet<Value>.Index {
        self.wrappedValue.index(after: i)
    }
    
    public func formIndex(after i: inout NGet<Value>.Index) {
        self.wrappedValue.formIndex(after: &i)
    }
    
    public subscript(position: NGet<Value>.Index) -> NGet<Value>.Element {
        self.map(up: { collection in
            guard position < collection.endIndex else {
                return nil
            }
            return collection[position]
        })
    }
}

extension NGet: BidirectionalCollection where Value: BidirectionalCollection, Value: MutableCollection, Value.Element: Equatable {
    public func index(before i: NGet<Value>.Index) -> NGet<Value>.Index {
        self.wrappedValue.index(before: i)
    }
    
    public func formIndex(before i: inout NGet<Value>.Index) {
        self.wrappedValue.formIndex(before: &i)
    }
}

extension NGet: RandomAccessCollection where Value: MutableCollection, Value: RandomAccessCollection, Value.Element: Equatable {
}
