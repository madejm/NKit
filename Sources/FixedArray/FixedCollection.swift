//
//  FixedCollection.swift
//  NKit
//
//  Created by Mejdej on 15/08/2025.
//

public protocol NextElement {
    associatedtype Element
    associatedtype Next: NextElement
    
    init(_ values: [Element])
    
    var count: Int { get }
    
    func getNextValue(depth: Int) -> Element
    func setNextValue(depth: Int, value: Element)
}

public enum CollectionEnd<Element>: NextElement {
    public typealias Next = CollectionEnd
    
    case end
    
    public init(_ values: [Element]) {
        self = .end
    }
    
    public var count: Int {
        0
    }
    
    public func getNextValue(depth: Int) -> Element {
        fatalError()
    }
    
    public func setNextValue(depth: Int, value: Element) {
    }
}

public final class FixedCollection<Element, Next>: NextElement
where Next: NextElement, Next.Element == Element {
    internal var value: Element
    internal let next: Next
    
    public init(_ values: [Element]) {
        var copy = values
        self.value = copy.removeFirst()
        self.next = .init(copy)
    }
    
    public var count: Int {
        next.count + 1
    }
    
    
    public func getNextValue(depth: Int) -> Element {
        guard depth > 0 else {
            return value
        }
        return next.getNextValue(depth: depth - 1)
    }
    
    public func setNextValue(depth: Int, value: Element) {
        guard depth > 0 else {
            self.value = value
            return
        }
        next.setNextValue(depth: depth - 1, value: value)
    }
}

public typealias FixedCollection1<Element> = FixedCollection<Element, CollectionEnd<Element>>
public typealias FixedCollection2<Element> = FixedCollection<Element, FixedCollection1<Element>>
public typealias FixedCollection3<Element> = FixedCollection<Element, FixedCollection2<Element>>

extension FixedCollection: Collection {
    public typealias Index = Int
    
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        next.count
    }
    
    public subscript(position: Int) -> Element {
        get {
            getNextValue(depth: position)
        }
        set {
            setNextValue(depth: position, value: newValue)
        }
    }
    
    public func index(after i: Int) -> Int {
        i + 1
    }
}

func test() {
    let col1: FixedCollection1<Int> = .init([0])
    let col2: FixedCollection2<Int> = .init([0, 1])
}
