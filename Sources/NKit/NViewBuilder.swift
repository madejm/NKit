import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

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
    
    public static func buildArray(_ components: [NView]) -> [NView] {
        components
    }
}

extension NView {
    internal func setParent(_ parent: NView) {
        if let v = self as? _View {
            //
        } else if let array = self as? [NView] {
            for item in array {
                item.setParent(parent)
            }
        } else if let forEach = self as? AnyNForEach {
            forEach.setNForEachParent(parent)
        } else {
            fatalError()
        }
    }
    
//    internal func VIEW_PRINT(indent: Int) -> String  {
//        if let v = self as? _View {
//            return indent.indent() + v.textFieldString + "\n"
//        } else if let array = self as? [NView] {
//            var res = ""
//            res += indent.indent()
//            res += "[\n"
//            
//            for v in array {
//                res += v.VIEW_PRINT(indent: indent + 1)
//            }
//            
//            res += indent.indent()
//            res += "]\n"
//            return res
//        } else if let forEach = self as? AnyNForEach {
//            return forEach.VIEW_PRINT(indent: indent + 1)
//        }
//        fatalError()
//    }
    
    internal func countViews(until end: AnyNForEach) -> (count: Int, stop: Bool) {
        if self is _View {
            return (1, false)
        } else if let array = self as? [NView] {
            var count: Int = 0
            
            for item in array {
                let result: (count: Int, stop: Bool) = item.countViews(until: end)
                count += result.count
                
                if result.stop {
                    return (count, true)
                }
            }
            
            return (count, false)
        } else if let forEach = self as? AnyNForEach {
            guard !forEach.isTheSameAs(end) else {
                return (0, true)
            }
            
            return forEach.viewsCountInCache(until: end)
        }
        fatalError()
    }
    
    internal var viewsCount: Int {
        if self is _View {
            return 1
        } else if let array = self as? [NView] {
            return array.viewsCount
        } else if let forEach = self as? AnyNForEach {
            let nViews: [NView] = forEach.forEachViews
            return nViews.viewsCount
//            return forEach.viewsCountInCache
        }
        fatalError("NView type not handled: \(String(describing: self))")
    }
    
    internal var viewsCountInCache: Int {
        if self is _View {
            return 1
        } else if let array = self as? [NView] {
            return array.viewsCount
        } else if let forEach = self as? AnyNForEach {
//            let nViews: [NView] = forEach.forEachViews
//            return nViews.viewsCount
            return forEach.viewsCountInCache
        }
        fatalError("NView type not handled: \(String(describing: self))")
    }
    
    internal func views(
        onChange: @escaping @MainActor (_ changeOffset: Int, _ changes: [NChange<_View>]) -> Void
    ) -> [_View] {
        if let view = self as? _View {
            return [view]
        } else if let array = self as? [NView] {
            let views: [_View] = array.mapToViews(
//                INFO: "ARRAY",
                onChange: {
                    onChange($0, $1)
                }
            )
            return views
        } else if let forEach = self as? AnyNForEach {
            let nViews: [NView] = forEach.forEachViews
            let views: [_View] = nViews.mapToViews(
//                INFO: "NFE \(forEach.DEBUG_LABEL)",
                onChange: { (changeOffset: Int, changes: [NChange<_View>]) in
                    let offset: Int = changeOffset + 0
                    
                    onChange(offset, changes)
                }
            )
            
//            forEach.onDataChange { [unowned forEach] (changes: [NChange<NView>]) in
            forEach.onDataChange { (viewsBeforeMe: Int, changes: [NChange<NView>]) in
                let changes: [NChange<_View>] = changes
                    .map { (change: NChange<NView>) in
                        switch change {
                        case .remove(let at, let count):
                            return .remove(at: at, count: count)
                        case .keep(let views):
                            return .keep(views: views.views(
                                onChange: onChange
                            ))
                        case .move(let from, let to, let views):
                            return .move(from: from, to: to, views: views.views(
                                onChange: onChange
                            ))
                        case .insert(let at, let views):
                            return .insert(at: at, views: views.views(
                                onChange: onChange
                            ))
                        }
                    }
                
//                let fe = forEach
//                let offset: Int = numberOfViewsBeforeMe()
                let offset: Int = viewsBeforeMe
                
                onChange(offset, changes)
            }
            
            return views
        }
        fatalError("NView type not handled: \(String(describing: self))")
    }
}

extension Array where Element == NView {
    @MainActor
    fileprivate func mapToViews(
//        INFO: String,
        onChange: @escaping @MainActor (_ changeOffset: Int, _ changes: [NChange<_View>]) -> Void
    ) -> [_View] {
        var views: [_View] = []
        
        for i in 0..<self.count {
            let nView: NView = self[i]
            
            let subviews: [_View] = nView.views(
                onChange: { (changeOffset: Int, changes: [NChange<_View>]) in
                    
//                    let start: Int = self.viewCount(upTo: i)
//                    let replaceOffset: Int = start + changeOffset
                    let replaceOffset: Int = changeOffset
                    
//                    let INFO_ = INFO
//                    let PRINT_ALL = self.VIEW_PRINT(upTo: self.count, indent: 0)
//                    let PRINT = self.VIEW_PRINT(upTo: i, indent: 0)
//                    let _s = self
                    
                    onChange(replaceOffset, changes)
                }
            )
            
            views.append(contentsOf: subviews)
        }
        
        return views
    }
}
