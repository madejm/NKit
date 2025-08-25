import Foundation

extension NBinding: Sequence where Value: MutableCollection, Value.Element: Equatable {
    public typealias Element = NBinding<Value.Element>
    public typealias Iterator = IndexingIterator<NBinding<Value>>
    public typealias SubSequence = Slice<NBinding<Value>>
}

extension NBinding: @preconcurrency Collection where Value: MutableCollection, Value.Element: Equatable {
    public typealias Index = Value.Index
    public typealias Indices = Value.Indices
    
    public var startIndex: NBinding<Value>.Index {
        self.wrappedValue.startIndex
    }
    
    public var endIndex: NBinding<Value>.Index {
        self.wrappedValue.endIndex
    }
    
    public var indices: Value.Indices {
        self.wrappedValue.indices
    }
    
    public func index(after i: NBinding<Value>.Index) -> NBinding<Value>.Index {
        self.wrappedValue.index(after: i)
    }
    
    public func formIndex(after i: inout NBinding<Value>.Index) {
        self.wrappedValue.formIndex(after: &i)
    }
    
    public subscript(position: NBinding<Value>.Index) -> NBinding<Value>.Element {
        self.value(index: position)
    }
}

extension NBinding: @preconcurrency BidirectionalCollection where Value: BidirectionalCollection, Value: MutableCollection, Value.Element: Equatable {
    public func index(before i: NBinding<Value>.Index) -> NBinding<Value>.Index {
        self.wrappedValue.index(before: i)
    }
    
    public func formIndex(before i: inout NBinding<Value>.Index) {
        self.wrappedValue.formIndex(before: &i)
    }
}

extension NBinding: @preconcurrency RandomAccessCollection where Value: RandomAccessCollection, Value: MutableCollection, Value.Element: Equatable {
}
