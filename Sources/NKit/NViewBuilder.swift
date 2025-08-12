import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

//public typealias ViewCreator = () -> [NView]

/// Abstraction over a view or collection of views (in `ForEach`)
/// Think as of SwiftUI's `View`
@MainActor
public protocol NView {}
extension _View: NView {}

#if swift(>=5.4)
@resultBuilder
public struct NViewBuilder {
}
#else
@_functionBuilder
public struct NViewBuilder {
}
#endif

extension NViewBuilder {
    public static func buildBlock(_ components: NView...) -> [NView] {
        components
    }
    
    public static func buildIf(_ value: NView?) -> NView {
        value ?? []
    }
}

extension Array: NView where Element == NView {}

extension NView {
    internal var viewsCount: Int {
        if self is _View {
            return 1
        } else if let array = self as? [NView] {
            return array.viewsCount
        } else if let forEach = self as? AnyNForEach {
            let nViews: [NView] = forEach.forEachViews
            return nViews.viewsCount
        }
        fatalError("NView type not handled: \(String(describing: self))")
    }
    
    internal func views(
        onChange: @escaping @MainActor (_ range: Range<Int>, _ newViews: [_View]) -> Void
    ) -> [_View] {
        if let view = self as? _View {
            return [view]
        } else if let array = self as? [NView] {
            let views: [_View] = array.mapToViews(onChange: {
                onChange($0, $1)
            })
            return views
        } else if let forEach = self as? AnyNForEach {
            let nViews: [NView] = forEach.forEachViews
            let views: [_View] = nViews.mapToViews(onChange: {
                onChange($0, $1)
            })
            
            forEach.onDataChange { (removeCount: Int, newViews: [NView]) in
                let changedViews: [_View] = newViews.views(onChange: onChange)
                
                onChange(0..<removeCount, changedViews)
            }
            
            return views
        }
        fatalError("NView type not handled: \(String(describing: self))")
    }
}

extension Array where Element == NView {
    @MainActor
    fileprivate var viewsCount: Int {
        self.reduce(into: 0) {
            $0 += $1.viewsCount
        }
    }
    
    @MainActor
    fileprivate func mapToViews(
        onChange: @escaping @MainActor (_ range: Range<Int>, _ newViews: [_View]) -> Void
    ) -> [_View] {
        var views: [_View] = []
        
        for i in 0..<self.count {
            let nView: NView = self[i]
            
            let subviews: [_View] = nView.views(onChange: { (range: Range<Int>, newViews: [_View]) in
                
                let start: Int = self.viewCount(upTo: i)
                let replaceRange: Range<Int> = (start + range.lowerBound)..<(start + range.upperBound)
                
                onChange(replaceRange, newViews)
            })
            
            views.append(contentsOf: subviews)
        }
        
        return views
    }
}

extension Array where Element == NView {
    @MainActor
    internal func viewCount(upTo index: Int) -> Int {
        guard index > 0 else {
            return 0
        }
        
        var sum: Int = 0
        
        for i in 0..<index {
            let view: NView = self[i]
            sum += view.viewsCount
        }
        
        return sum
    }
}
