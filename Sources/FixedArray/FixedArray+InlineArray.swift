//
//  FixedArray+InlineArray.swift
//  NKit
//
//  Created by Mejdej on 15/08/2025.
//

#if swift(>=6.2)
@available(macOS 26.0, iOS 26.0, *)
extension FixedArray {
    public init?<let count: Int>(_ inlineArray: InlineArray<count, Element>) {
        guard Size.count == count else {
            return nil
        }
        self.array = Array(inlineArray)
    }
}

@available(macOS 26.0, iOS 26.0, *)
extension InlineArray {
    public init?<Size>(_ fixedArray: FixedArray<Size, Element>) {
        self.init(fixedArray.array)
    }
}

@available(macOS 26.0, iOS 26.0, *)
extension FixedArray {
    public init(_ inlineArray: InlineArray<1, Element>) where Size == FixedArraySize1 {
        self.array = Array(inlineArray)
    }
    
    public init(_ inlineArray: InlineArray<2, Element>) where Size == FixedArraySize2 {
        self.array = Array(inlineArray)
    }
    
    public init(_ inlineArray: InlineArray<3, Element>) where Size == FixedArraySize3 {
        self.array = Array(inlineArray)
    }
}

@available(macOS 26.0, iOS 26.0, *)
extension InlineArray {
    public init(_ fixedArray: FixedArray1<Element>) where count == 1 {
        self.init(fixedArray.array)!
    }
    
    public init(_ fixedArray: FixedArray2<Element>) where count == 2 {
        self.init(fixedArray.array)!
    }
    
    public init(_ fixedArray: FixedArray3<Element>) where count == 3 {
        self.init(fixedArray.array)!
    }
}

@available(macOS 26.0, *)
func testArrayInlineArray() {
    let array: Array<Int> = [1, 2, 3]
    let inlineArray: InlineArray<3, Int>? = .init(array)
}

@available(macOS 26.0, *)
func testInlineArrayArray() {
    let inlineArray: InlineArray<3, Int> = [1, 2, 3]
    let array: Array<Int> = .init(inlineArray)
}

@available(macOS 26.0, *)
func testFixedArrayInlineArray() {
    let fixedArray: FixedArray3<Int> = .init(1, 2, 3)
    let inlineArray3: InlineArray<3, Int>? = .init(fixedArray)
    let inlineArray4: InlineArray<4, Int>? = .init(fixedArray)
}

@available(macOS 26.0, *)
func testInlineArrayFixedArray() {
    let inlineArray: InlineArray<3, Int> = [1, 2, 3]
    let fixedArray: FixedArray3<Int>? = .init(inlineArray)
}

#endif
