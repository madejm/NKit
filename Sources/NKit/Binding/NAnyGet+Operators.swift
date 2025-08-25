//
//  NAnyGet+Operators.swift
//  NKit
//
//  Created by Mejdej on 25/08/2025.
//

import Foundation

extension NAnyGet {
    fileprivate func mapExpression(
        _ expression: @escaping (Value, Value) -> Bool,
        _ value: Value
    ) -> NGet<Bool> {
        self.get.map(
            up: {
                let result: Bool = expression($0, value)
                return result
            }
        )
    }
    
    fileprivate func mapExpression(
        _ value: Value,
        _ expression: @escaping (Value, Value) -> Bool
    ) -> NGet<Bool> {
        self.get.map(
            up: {
                let result: Bool = expression(value, $0)
                return result
            }
        )
    }
    
    fileprivate func mapExpression(
        _ expression: @escaping (Value, @autoclosure () throws -> Value) throws -> Bool,
        _ value: @autoclosure @escaping () -> Value
    ) -> NGet<Bool> {
        self.get.map(
            up: {
                let result: Bool = try! expression($0, value())
                return result
            }
        )
    }
    
    fileprivate func mapExpression(
        _ value: @autoclosure @escaping () -> Value,
        _ expression: @escaping @Sendable (Value, @autoclosure () throws -> Value) throws -> Bool
    ) -> NGet<Bool> {
        self.get.map(
            up: {
                let result: Bool = try! expression(value(), $0)
                return result
            }
        )
    }
    
    fileprivate func mapExpression(
        _ expression: @escaping (Value, Value) -> Bool,
        _ another: any NAnyGet<Value>
    ) -> NGet<Bool> {
        NGet<Bool>.combine(self, another) {
            expression($0, $1)
        }
    }
    
    fileprivate func mapExpression(
        _ expression: @escaping (Value, @autoclosure () throws -> Value) throws -> Bool,
        _ another: any NAnyGet<Value>
    ) -> NGet<Bool> {
        NGet<Bool>.combine(self, another) {
            try! expression($0, $1)
        }
    }
}

@MainActor
public func == <T: Equatable>(lhs: any NAnyGet<T>, rhs: T) -> NGet<Bool> {
    lhs.mapExpression(==, rhs)
}

@MainActor
public func == <T: Equatable>(lhs: T, rhs: any NAnyGet<T>) -> NGet<Bool> {
    rhs.mapExpression(lhs, ==)
}

@MainActor
public func == <T: Equatable>(lhs: any NAnyGet<T>, rhs: any NAnyGet<T>) -> NGet<Bool> {
    lhs.mapExpression(==, rhs)
}

@MainActor
public func != <T: Equatable>(lhs: any NAnyGet<T>, rhs: T) -> NGet<Bool> {
    lhs.mapExpression(!=, rhs)
}

@MainActor
public func != <T: Equatable>(lhs: T, rhs: any NAnyGet<T>) -> NGet<Bool> {
    rhs.mapExpression(lhs, !=)
}

@MainActor
public func != <T: Equatable>(lhs: any NAnyGet<T>, rhs: any NAnyGet<T>) -> NGet<Bool> {
    lhs.mapExpression(!=, rhs)
}

@MainActor
public func > <T: Comparable>(lhs: any NAnyGet<T>, rhs: T) -> NGet<Bool> {
    lhs.mapExpression(>, rhs)
}

@MainActor
public func > <T: Comparable>(lhs: T, rhs: any NAnyGet<T>) -> NGet<Bool> {
    rhs.mapExpression(lhs, >)
}

@MainActor
public func > <T: Comparable>(lhs: any NAnyGet<T>, rhs: any NAnyGet<T>) -> NGet<Bool> {
    lhs.mapExpression(>, rhs)
}

@MainActor
public func >= <T: Comparable>(lhs: any NAnyGet<T>, rhs: T) -> NGet<Bool> {
    lhs.mapExpression(>=, rhs)
}

@MainActor
public func >= <T: Comparable>(lhs: T, rhs: any NAnyGet<T>) -> NGet<Bool> {
    rhs.mapExpression(lhs, >=)
}

@MainActor
public func >= <T: Comparable>(lhs: any NAnyGet<T>, rhs: any NAnyGet<T>) -> NGet<Bool> {
    lhs.mapExpression(>=, rhs)
}

@MainActor
public func < <T: Comparable>(lhs: any NAnyGet<T>, rhs: T) -> NGet<Bool> {
    lhs.mapExpression(<, rhs)
}

@MainActor
public func < <T: Comparable>(lhs: T, rhs: any NAnyGet<T>) -> NGet<Bool> {
    rhs.mapExpression(lhs, <)
}

@MainActor
public func < <T: Comparable>(lhs: any NAnyGet<T>, rhs: any NAnyGet<T>) -> NGet<Bool> {
    lhs.mapExpression(<, rhs)
}

@MainActor
public func <= <T: Comparable>(lhs: any NAnyGet<T>, rhs: T) -> NGet<Bool> {
    lhs.mapExpression(<=, rhs)
}

@MainActor
public func <= <T: Comparable>(lhs: T, rhs: any NAnyGet<T>) -> NGet<Bool> {
    rhs.mapExpression(lhs, <=)
}

@MainActor
public func <= <T: Comparable>(lhs: any NAnyGet<T>, rhs: any NAnyGet<T>) -> NGet<Bool> {
    lhs.mapExpression(<=, rhs)
}

extension NAnyGet where Value: SignedNumeric {
    public static prefix func -(original: Self) -> NGet<Value> {
        return original.get.map(
            up: {
                -$0
            }
        )
    }
}

extension NAnyGet {
    public static func ??<M>(
        _ self: Self,
        _ valueForNil: @escaping @autoclosure () -> M
    ) -> NGet<M> where Value == M? {
        self.get.map(
            some: { (value: M) -> M in
                value
            },
            none: {
                valueForNil()
            }
        )
    }
}

@MainActor
public func || (lhs: any NAnyGet<Bool>, rhs: @autoclosure @escaping () -> Bool) -> NGet<Bool> {
    lhs.mapExpression(||, rhs())
}

@MainActor
public func || (lhs: Bool, rhs: any NAnyGet<Bool>) -> NGet<Bool> {
    rhs.mapExpression(||, lhs)
}

@MainActor
public func || (lhs: any NAnyGet<Bool>, rhs: any NAnyGet<Bool>) -> NGet<Bool> {
    lhs.mapExpression(||, rhs)
}

@MainActor
public func && (lhs: any NAnyGet<Bool>, rhs: @autoclosure @escaping () -> Bool) -> NGet<Bool> {
    lhs.mapExpression(&&, rhs())
}

@MainActor
public func && (lhs: Bool, rhs: any NAnyGet<Bool>) -> NGet<Bool> {
    rhs.mapExpression(&&, lhs)
}

@MainActor
public func && (lhs: any NAnyGet<Bool>, rhs: any NAnyGet<Bool>) -> NGet<Bool> {
    lhs.mapExpression(&&, rhs)
}

extension NAnyGet where Value == Bool {
    public static prefix func !(original: Self) -> NGet<Value> {
        return original.get.map(
            up: {
                !$0
            }
        )
    }
}
