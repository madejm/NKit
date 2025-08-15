//
//  FixedArray+BasicProtocols.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

extension FixedArray: Equatable where Element: Equatable {
}

extension FixedArray: Hashable where Element: Hashable {
    public func hash(into hasher: inout Hasher) {
        array.hash(into: &hasher)
    }
}

extension FixedArray: Encodable where Element: Encodable {
    public func encode(to encoder: any Encoder) throws {
        try array.encode(to: encoder)
    }
}

extension FixedArray: Decodable where Element: Decodable {
    public init(from decoder: any Decoder) throws {
        let array: Array<Element> = try .init(from: decoder)
        self.init(array)!
    }
}

//extension FixedArray: ExpressibleByArrayLiteral {
//    public init(arrayLiteral elements: Element...) {
//        self.init(elements)!
//    }
//}
