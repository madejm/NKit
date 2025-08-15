//
//  FixedArrayTests.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

import Foundation
import Testing
import NKit
@testable import FixedArray

@Suite("FixedArrayTests")
@MainActor
struct FixedArrayTests {
    @Test func testInits() {
        let constantArray1: FixedArray3<Int> = .init(1, 2, 3)
        #expect(constantArray1 == [1, 2, 3])
        
        let constantArray2: FixedArray3<Int> = .init(repeating: 0)
        #expect(constantArray2 == [0, 0, 0])
        
        let constantArray3: FixedArray3<Int> = .init([4, 5, 6])!
        #expect(constantArray3 == [4, 5, 6])
    }
    
    enum Test_Size0: FixedArraySize {
        static var count: Int { 0 }
    }
    
    @Test func testFixedArrayFromArray() {
        let array0: [Int] = []
        let constantArray0: FixedArray<Test_Size0, Int>? = .init(array0)
        #expect(constantArray0?.count == 0)
        
        let constantArray1: FixedArray1<Int>? = .init(array0)
        #expect(constantArray1 == nil)
        
        let array1: [Int] = [1]
        let constantArray2: FixedArray2<Int>? = .init(array1)
        #expect(constantArray2 == nil)
        
        let array3: [Int] = [1, 2, 3]
        let constantArray3: FixedArray3<Int>? = .init(array3)
        #expect(constantArray3?.count == 3)
    }
    
    @Test func testArrayFromFixedArray() {
        let constantArray1: FixedArray3<Int> = .init(1, 2, 3)
        let array1: [Int] = Array(constantArray1)
        
        #expect(array1.count == 3)
    }
    
    @Test func testSubscriptGet() {
        let constantArray1: FixedArray3<Int> = .init(1, 2, 3)
        
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
        var constantArray1: FixedArray3<Int> = .init(1, 2, 3)
        
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
    
    @Test func testEquals() {
        #expect(FixedArray3<Int>(1, 2, 3) == FixedArray3<Int>(1, 2, 3))
        #expect(FixedArray3<Int>(1, 2, 3) != FixedArray2<Int>(1, 2))
        
        #expect(FixedArray3<Int>(1, 2, 3) == [1, 2, 3])
        #expect(FixedArray3<Int>(1, 2, 3) != [1, 2])
        #expect([1, 2, 3] == FixedArray3<Int>(1, 2, 3))
        #expect([1, 2, 3] != FixedArray2<Int>(1, 2))
        
        let array: FixedArray3<Int> = .init(1, 2, 3)
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
    
    enum Test_FixedArraySize2: FixedArraySize { static var count: Int { 2 } }
    
    @Test func testEqualsSize() {
        let array2: FixedArray2<Int> = .init(1, 2)
        let array3: FixedArray3<Int> = .init(1, 2, 3)
        
        
        let testArray1: FixedArray<Test_FixedArraySize2, Int> = .init([1, 2])!
        #expect((testArray1 == array3) == false)
        
        let testArray2: FixedArray<Test_FixedArraySize2, Int> = .init([0, 1])!
        #expect((testArray2 == array2) == false)
        
        let testArray3: FixedArray<Test_FixedArraySize2, Int> = .init([1, 2])!
        #expect(testArray3 == array2)
        
        let testArray4: FixedArray<Test_FixedArraySize2, Int> = .init([1, 2])!
        #expect(testArray4 != array3)
        
        let testArray5: FixedArray<Test_FixedArraySize2, Int> = .init([0, 1])!
        #expect(testArray5 != array2)
        
        let testArray6: FixedArray<Test_FixedArraySize2, Int> = .init([1, 2])!
        #expect((testArray6 != array2) == false)
    }
    
    @Test func testHash() {
        let FixedArray: FixedArray3<Int> = .init(1, 2, 3)
        let array: [Int] = [1, 2, 3]
        
        #expect(FixedArray.hashValue == array.hashValue)
    }
    
    @Test func testEncoding() throws {
        let FixedArray: FixedArray3<Int> = .init(1, 2, 3)
        
        let json: Data = try JSONEncoder().encode(FixedArray)
        let array: [Int] = try JSONDecoder().decode([Int].self, from: json)
        
        #expect(FixedArray == array)
    }
    
    @Test func testDecoding() throws {
        let array: [Int] = [1, 2, 3]
        
        let json: Data = try JSONEncoder().encode(array)
        let FixedArray: FixedArray3<Int> = try JSONDecoder().decode(FixedArray3<Int>.self, from: json)
        
        #expect(array == FixedArray)
    }
    
    @Test func testBinding() {
        @NState var state: FixedArray4<Int> = .init(1, 2, 3, 4)
        
        let binding1: NBinding<FixedArray4<Int>> = $state
        let get1: NGet<FixedArray4<Int>> = binding1.get
        
        let binding2: NBinding<[Int]> = binding1
            .map(
                up: {
                    Array($0)
                },
                down: {
                    FixedArray4<Int>($0) ?? FixedArray4<Int>(repeating: -1)
                }
            )
        
        let get2: NGet<[Int]> = get1
            .map(up: {
                Array($0)
            })
        
        var result: FixedArray4<Int>!
        get1.onChange { newValue in
            result = newValue
        }
        
        var bool: Bool
        
        #expect(state == [1, 2, 3, 4])
        #expect(binding1.wrappedValue == [1, 2, 3, 4])
        #expect(get1.wrappedValue == [1, 2, 3, 4])
        #expect(binding2.wrappedValue == [1, 2, 3, 4])
        #expect(get2.wrappedValue == [1, 2, 3, 4])
        
        state = .init(5, 6, 7, 8)
        
        #expect(binding1.wrappedValue == [5, 6, 7, 8])
        #expect(get1.wrappedValue == [5, 6, 7, 8])
        bool = result == [5, 6, 7, 8]
        #expect(bool == true)
        #expect(binding2.wrappedValue == [5, 6, 7, 8])
        #expect(get2.wrappedValue == [5, 6, 7, 8])
        
        binding2.wrappedValue = [1, 3, 5, 7]
        
        #expect(binding1.wrappedValue == [1, 3, 5, 7])
        #expect(get1.wrappedValue == [1, 3, 5, 7])
        bool = result == [1, 3, 5, 7]
        #expect(bool == true)
        #expect(binding2.wrappedValue == [1, 3, 5, 7])
        #expect(get2.wrappedValue == [1, 3, 5, 7])
        
        binding2.wrappedValue = [0, 2, 4, 6, 8]
        
        #expect(binding1.wrappedValue == [-1, -1, -1, -1])
        #expect(get1.wrappedValue == [-1, -1, -1, -1])
        bool = result == [-1, -1, -1, -1]
        #expect(bool == true)
        #expect(binding2.wrappedValue == [-1, -1, -1, -1])
        #expect(get2.wrappedValue == [-1, -1, -1, -1])
    }
    
    @Test func testMap() {
        let array: FixedArray4<Int> = .init(1, 2, 3, 4)
        
        let mapped1: [String] = array
            .map {
                String($0)
            }
        #expect(mapped1 == ["1", "2", "3", "4"])
        
        let mapped2 = array
            .map {
                String($0)
            }
        #expect(mapped2 is FixedArray4<String>)
        #expect(mapped2 == ["1", "2", "3", "4"])
        
        let mapped3: FixedArray4<String> = array
            .map {
                String($0)
            }
        #expect(mapped3 == ["1", "2", "3", "4"])
    }
    
    @Test func testAdd() {
        let array: FixedArray4<Int> = .init(1, 2, 3, 4)
        
        let result1: [Int] = array + [5, 6]
        #expect(result1 == [1, 2, 3, 4, 5, 6])
        
        let result2: [Int] = [0] + array
        #expect(result2 == [0, 1, 2, 3, 4])
        
        var result3: [Int] = [7, 8]
        result3 += array
        #expect(result3 == [7, 8, 1, 2, 3, 4])
        
        let result4: FixedArray4<Int>? = array + FixedArray4<Int>(5, 6, 7, 8)
        #expect(result4 == nil)
        
        let result5: FixedArray4<Int>? = array + FixedArray4<Int>(5, 6, 7, 8)
        #expect(result5 != [1, 2, 3, 4, 5, 6])
        
        let result6: FixedArray6<Int>? = array + FixedArray2<Int>(5, 6)
        #expect(result6 == [1, 2, 3, 4, 5, 6])
    }
}
