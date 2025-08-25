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
    
    public static func buildExpression(_ expression: NView) -> NView {
        expression
    }
    
    public static func buildOptional(_ component: NView?) -> NView {
        component ?? []
    }
    
    public static func buildIf(_ value: NView?) -> NView {
        value ?? []
    }
    
    public static func buildEither(first component: NView) -> NView {
        component
    }
    
    public static func buildEither(second component: NView) -> NView {
        component
    }
    
    public static func buildArray(_ components: [NView]) -> [NView] {
        components
    }
    
    public static func buildLimitedAvailability(_ component: NView) -> NView {
        component
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
        } else if let nIf = self as? NIf {
            nIf.setNIfParent(parent)
        } else if let forEach = self as? NForEach {
            forEach.setNForEachParent(parent)
        } else {
            fatalError()
        }
    }
    
    internal func countViews(until end: AnyObject) -> (count: Int, stop: Bool) {
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
        } else if let nIf = self as? NIf {
            guard nIf !== end else {
                return (0, true)
            }
            
            return nIf.viewsCountInCache(until: end)
        } else if let forEach = self as? NForEach {
            guard forEach !== end else {
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
        } else if let forEach = self as? NForEach {
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
            return array.viewsCountInCache
        } else if let forEach = self as? NForEach {
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
                onChange: {
                    onChange($0, $1)
                }
            )
            return views
        } else if let nIf = self as? NIf {
            let nViews: [NView] = nIf.ifViews
            let views: [_View] = nViews.mapToViews(
                onChange: { (changeOffset: Int, changes: [NChange<_View>]) in
                    onChange(changeOffset, changes)
                }
            )
            
            nIf.onDataChange { (viewsBeforeMe: Int, changes: [NChange<NView>]) in
                let changes: [NChange<_View>] = changes.mapChanges(onChange: onChange)
                
                onChange(viewsBeforeMe, changes)
            }
            
            return views
        } else if let forEach = self as? NForEach {
            let nViews: [NView] = forEach.forEachViews
            let views: [_View] = nViews.mapToViews(
                onChange: { (changeOffset: Int, changes: [NChange<_View>]) in
                    let offset: Int = changeOffset + 0
                    
                    onChange(offset, changes)
                }
            )
            
            forEach.onDataChange { (viewsBeforeMe: Int, changes: [NChange<NView>]) in
                let changes: [NChange<_View>] = changes.mapChanges(onChange: onChange)
                
                onChange(viewsBeforeMe, changes)
            }
            
            return views
        }
        fatalError("NView type not handled: \(String(describing: self))")
    }
}

extension Array where Element == NView {
    @MainActor
    fileprivate func mapToViews(
        onChange: @escaping @MainActor (_ changeOffset: Int, _ changes: [NChange<_View>]) -> Void
    ) -> [_View] {
        var views: [_View] = []
        
        for i in 0..<self.count {
            let nView: NView = self[i]
            
            let subviews: [_View] = nView.views(
                onChange: { (changeOffset: Int, changes: [NChange<_View>]) in
                    onChange(changeOffset, changes)
                }
            )
            
            views.append(contentsOf: subviews)
        }
        
        return views
    }
}

extension Array where Element == NChange<NView> {
    @MainActor
    fileprivate func mapChanges(
        onChange: @escaping @MainActor (_ changeOffset: Int, _ changes: [NChange<_View>]) -> Void
    ) -> [NChange<_View>] {
        self.map { (change: NChange<NView>) in
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
    }
}
