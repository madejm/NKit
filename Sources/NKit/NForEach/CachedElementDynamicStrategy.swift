//
//  CachedElementDynamicStrategy.swift
//  NKit
//
//  Created by Mejdej on 21/02/2026.
//

@MainActor
internal protocol CachedElementDynamicStrategy {
    static func storage<T: AnyObject & NCacheable>(_ value: T) -> any CachedElementDynamicStorage<T>
}

internal enum CachedElementDynamicStrong: CachedElementDynamicStrategy {
    
    internal static func storage<T: AnyObject & NCacheable>(_ value: T) -> any CachedElementDynamicStorage<T> {
        CachedElementDynamicStorageStrong(value)
    }
}

internal enum CachedElementDynamicWeak: CachedElementDynamicStrategy {
    
    internal static func storage<T: AnyObject & NCacheable>(_ value: T) -> any CachedElementDynamicStorage<T> {
        CachedElementDynamicStorageWeak(value)
    }
}

@MainActor
internal protocol CachedElementDynamicStorage<T> {
    associatedtype T: AnyObject & NCacheable
    
    var value: T? { get set }
}

private struct CachedElementDynamicStorageStrong<T: AnyObject & NCacheable>: CachedElementDynamicStorage {
    var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}

internal struct CachedElementDynamicStorageWeak<T: AnyObject & NCacheable>: CachedElementDynamicStorage {
    weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}
