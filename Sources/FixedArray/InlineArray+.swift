//
//  InlineArray+.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

#if swift(>=6.2)
@available(macOS 26.0, iOS 26.0, *)
extension InlineArray: @retroactive Equatable where Element: Equatable {
    public static func == (lhs: InlineArray<count, Element>, rhs: InlineArray<count, Element>) -> Bool {
        Array(lhs) == Array(lhs)
    }
}

@available(macOS 26.0, iOS 26.0, *)
extension InlineArray {
    package init?(_ array: Array<Element>) {
        guard array.count == count else {
            return nil
        }
        self.init() { (index: InlineArray<count, Element>.Index) in
            array[index]
        }
    }
}

@available(macOS 26.0, iOS 26.0, *)
extension Array {
    package init<let count: Int>(_ inlineArray: InlineArray<count, Element>) {
        var array: [Element] = []
        array.reserveCapacity(inlineArray.count)
        
        for index in inlineArray.indices {
            array.append(inlineArray[index])
        }
        self = array
    }
}
#endif
