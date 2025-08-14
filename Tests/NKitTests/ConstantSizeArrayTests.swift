//
//  ConstantSizeArrayTests.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

import Foundation
import Testing
@testable import NKit

@Suite("ConstantSizeArrayTests")
@MainActor
struct ConstantSizeArrayTests {
    @Test func testInits() {
        let constantArray1: ConstantSizeArray<Int> = .init(1, 2, 3)
        #expect(constantArray1.count == 3)
        
        let constantArray2: ConstantSizeArray<Int>? = .init(repeating: 0, count: 3)
        #expect(constantArray2?.count == 3)
        
        let constantArray3: ConstantSizeArray<Int> = [4, 5, 6]
        #expect(constantArray3 == [4, 5, 6])
    }
    
    @Test func testConstantSizeArrayFromArray() {
        let array1: [Int] = []
        let constantArray1: ConstantSizeArray<Int>? = .init(array1)
        
        #expect(constantArray1 == nil)
        
        let array2: [Int] = [1, 2, 3]
        let constantArray2: ConstantSizeArray<Int>? = .init(array2)
        
        #expect(constantArray2?.count == 3)
    }
    
    @Test func testArrayFromConstantSizeArray() {
        let constantArray1: ConstantSizeArray<Int> = .init(1, 2, 3)
        let array1: [Int] = Array(constantArray1)
        
        #expect(array1.count == 3)
    }
    
    @Test func testSubscriptGet() {
        let constantArray1: ConstantSizeArray<Int> = .init(1, 2, 3)
        
        let element0: Int = constantArray1[0]
        #expect(element0 == 1)
        
        let element1: Int? = constantArray1[1]
        #expect(element1 == 2)
        
        let element3: Int? = constantArray1[3]
        #expect(element3 == nil)
        
        let first: Int = constantArray1.first
        #expect(first == 1)
        
        let last: Int = constantArray1.last
        #expect(last == 3)
        
        let slice0_2: ArraySlice<Int>? = constantArray1[0..<2]
        #expect(slice0_2 == [1, 2])
        
        let slice1_4: ArraySlice<Int>? = constantArray1[1..<4]
        #expect(slice1_4 == nil)
    }
    
    @Test func testSubscriptSet() {
        var constantArray1: ConstantSizeArray<Int> = .init(1, 2, 3)
        
        constantArray1[0] = 4
        #expect(constantArray1 == [4, 2, 3])
        
        constantArray1[0] = Optional(5)
        #expect(constantArray1 == [5, 2, 3])
        
        constantArray1[0] = nil
        #expect(constantArray1 == [5, 2, 3])
        
        constantArray1[3] = 66
        #expect(constantArray1 == [5, 2, 3])
        
        constantArray1[0..<2] = [7, 8]
        #expect(constantArray1 == [7, 8, 3])
        
        constantArray1[1..<3] = [0, 0, 0]
        #expect(constantArray1 == [7, 8, 3])
        
        constantArray1[1..<4] = [9, 0]
        #expect(constantArray1 == [7, 8, 3])
        
        constantArray1.replaceSubrange(1..<3, with: [10, 11])
        #expect(constantArray1 == [7, 10, 11])
        
        constantArray1.replaceSubrange(1..<2, with: [0, 0, 0])
        #expect(constantArray1 == [7, 10, 11])
        
        constantArray1.replaceSubrange(1..<4, with: [12, 13])
        #expect(constantArray1 == [7, 10, 11])
    }
    
    @Test func testOperators() {
        #expect(ConstantSizeArray<Int>(1, 2, 3) == ConstantSizeArray<Int>(1, 2, 3))
        #expect(ConstantSizeArray<Int>(1, 2, 3) != ConstantSizeArray<Int>(1, 2))
        
        #expect(ConstantSizeArray<Int>(1, 2, 3) == [1, 2, 3])
        #expect(ConstantSizeArray<Int>(1, 2, 3) != [1, 2])
        #expect([1, 2, 3] == ConstantSizeArray<Int>(1, 2, 3))
        #expect([1, 2, 3] != ConstantSizeArray<Int>(1, 2))
        
        let array: ConstantSizeArray<Int> = .init(1, 2, 3)
        let collection1: any Collection<Int> = [1, 2, 3]
        let collection2: any Collection<Int> = [1, 2]
        
        let bool1: Bool = array == collection1
        #expect(bool1 == true)
        
        let bool2: Bool = array != collection2
        #expect(bool2 == true)
        
        let bool3: Bool = collection1 == array
        #expect(bool3 == true)
        
        let bool4: Bool = collection2 != array
        #expect(bool4 == true)
    }
    
    @Test func testHash() {
        let constantSizeArray: ConstantSizeArray<Int> = .init(1, 2, 3)
        let array: [Int] = [1, 2, 3]
        
        #expect(constantSizeArray.hashValue == array.hashValue)
    }
    
    @Test func testEncoding() throws {
        let constantSizeArray: ConstantSizeArray<Int> = .init(1, 2, 3)
        
        let json: Data = try JSONEncoder().encode(constantSizeArray)
        let array: [Int] = try JSONDecoder().decode([Int].self, from: json)
        
        #expect(constantSizeArray == array)
    }
    
    @Test func testDecoding() throws {
        let array: [Int] = [1, 2, 3]
        
        let json: Data = try JSONEncoder().encode(array)
        let constantSizeArray: ConstantSizeArray<Int> = try JSONDecoder().decode(ConstantSizeArray<Int>.self, from: json)
        
        #expect(array == constantSizeArray)
    }
}
