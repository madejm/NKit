//
//  CustomIndex.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

internal protocol CustomIndexDescription {
    static var name: String? { get }
}

extension CustomIndexDescription {
    internal static var name: String? {
        nil
    }
}

internal struct CustomIndex<T: CustomIndexDescription>: RawRepresentable, Equatable {
    
    internal var rawValue: Int
    
    internal init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension CustomIndex: ExpressibleByIntegerLiteral {
    internal init(integerLiteral value: Int) {
        self.rawValue = value
    }
}

extension CustomIndex: Comparable {
    internal static func < (lhs: CustomIndex, rhs: CustomIndex) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension CustomIndex: CustomStringConvertible {
    internal var description: String {
        if let name: String = T.name {
            return "\(name)( \(rawValue) )"
        } else {
            return "CustomIndex<\(String(describing: T.self))>( \(rawValue) )"
        }
    }
}

extension CustomIndex: CustomDebugStringConvertible {
    internal var debugDescription: String {
        description
    }
}

extension CustomIndex: CustomReflectable {
    internal var customMirror: Mirror {
        Mirror(reflecting: rawValue)
    }
}

internal func == <T>(lhs: CustomIndex<T>, rhs: Int) -> Bool {
    lhs.rawValue == rhs
}

internal func == <T>(lhs: Int, rhs: CustomIndex<T>) -> Bool {
    lhs == rhs.rawValue
}

internal func + <T>(lhs: CustomIndex<T>, rhs: CustomIndex<T>) -> CustomIndex<T> {
    .init(rawValue: lhs.rawValue + rhs.rawValue)
}

internal func + <T>(lhs: CustomIndex<T>, rhs: Int) -> CustomIndex<T> {
    .init(rawValue: lhs.rawValue + rhs)
}

internal func + <T>(lhs: Int, rhs: CustomIndex<T>) -> CustomIndex<T> {
    .init(rawValue: lhs + rhs.rawValue)
}

internal func += <T>(lhs: inout CustomIndex<T>, rhs: CustomIndex<T>) {
    lhs.rawValue += rhs.rawValue
}

internal func += <T>(lhs: inout CustomIndex<T>, rhs: Int) {
    lhs.rawValue += rhs
}

internal func -= <T>(lhs: inout CustomIndex<T>, rhs: CustomIndex<T>) {
    lhs.rawValue -= rhs.rawValue
}

internal func -= <T>(lhs: inout CustomIndex<T>, rhs: Int) {
    lhs.rawValue -= rhs
}
