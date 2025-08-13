//
//  CustomIndex+Types.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

internal enum StackIndexEnum: CustomIndexDescription {
    internal static var name: String? { "StackIndex" }
}
internal typealias StackIndex = CustomIndex<StackIndexEnum>

internal enum NViewIndexEnum: CustomIndexDescription {
    internal static var name: String? { "NViewIndex" }
}
internal typealias NViewIndex = CustomIndex<NViewIndexEnum>

//extension Range {
//    func intRange<T>() -> Range<Int> where Bound == CustomIndex<T> {
//        self.lowerBound.rawValue..<self.upperBound.rawValue
//    }
//}

extension Array where Element: _View {
    internal subscript(_ index: StackIndex) -> Element {
        get {
            self[index.rawValue]
        }
        set {
            self[index.rawValue] = newValue
        }
    }
}

extension _Stack {
    internal func insertArrangedSubview(_ view: _View, at index: StackIndex) {
        self.insertArrangedSubview(view, at: index.rawValue)
    }
}
