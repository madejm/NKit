import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
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
    
//    @available(*, unavailable)
//    public static func buildOptional(_ component: NView?) -> NView {
//        component ?? []
//    }
    
    @available(*, deprecated, message: "An `if` statement does not work for dynamically changing content. Instead use `NIf` with a binding.")
//    @available(*, unavailable)
    public static func buildIf(_ value: NView?) -> NView {
        value ?? []
    }
    
    @available(*, deprecated, message: "An `if else` statement does not work for dynamically changing content. Instead use `NIf` with a binding.")
    public static func buildEither(first component: NView) -> NView {
        component
    }
    
    @available(*, deprecated, message: "An `if else` statement does not work for dynamically changing content. Instead use `NIf` with a binding.")
    public static func buildEither(second component: NView) -> NView {
        component
    }
    
    @available(*, deprecated, message: "A `for in` statement does not work for dynamically changing content. Instead use `NForEach` with a constant or binding.")
    public static func buildArray(_ components: [NView]) -> [NView] {
        components
    }
    
//    @available(*, unavailable)
//    public static func buildLimitedAvailability(_ component: NView) -> NView {
//        component
//    }
}

extension NView {
    internal func setParent(_ parent: NView) {
        switch self.unpacked {
        case .view:
            break
        case .array(let array):
            for item in array {
                item.setParent(parent)
            }
        case .forEach(let nForEach):
            nForEach.setNForEachParent(parent)
        case .if(let nIf):
            nIf.setNIfParent(parent)
        case .otherObject:
            break
        case .other:
            break
        }
    }
    
    internal func countViews(until end: AnyObject) -> (count: Int, stop: Bool) {
        switch self.unpacked {
        case .view:
            return (1, false)
        case .array(let array):
            var count: Int = 0
            
            for item in array {
                let result: (count: Int, stop: Bool) = item.countViews(until: end)
                count += result.count
                
                if result.stop {
                    return (count, true)
                }
            }
            
            return (count, false)
        case .forEach(let nForEach):
            guard nForEach !== end else {
                return (0, true)
            }
            
            return nForEach.forEachViewsCountInCache(until: end)
        case .if(let nIf):
            guard nIf !== end else {
                return (0, true)
            }
            
            return nIf.ifViewsCountInCache(until: end)
        case .otherObject:
            return (1, false)
        case .other:
            return (1, false)
        }
    }
    
    internal var viewsCount: Int {
        switch self.unpacked {
        case .view:
            return 1
        case .array(let array):
            return array.arrayViewsCount()
        case .forEach(let nForEach):
            let nViews: [NView] = nForEach.forEachViews
            return nViews.arrayViewsCount()
//            return nForEach.viewsCountInCache
        case .if(let nIf):
            let nViews: [NView] = nIf.ifViews
            return nViews.arrayViewsCount()
        case .otherObject:
            return 1
        case .other:
            return 1
        }
    }
    
    internal var viewsCountInCache: Int {
        switch self.unpacked {
        case .view:
            return 1
        case .array(let array):
            return array.arrayViewsCountInCache
        case .forEach(let nForEach):
//            let nViews: [NView] = nForEach.forEachViews
//            return nViews.viewsCount
            return nForEach.forEachViewsCountInCache
        case .if(let nIf):
            fatalError("Unhandled: \(nIf)")
        case .otherObject:
            return 1
        case .other:
            return 1
        }
    }
    
    internal func views(
        onChange: @escaping @MainActor (_ changeOffset: Int, _ changes: [NChange<_View>]) -> Void
    ) -> [_View] {
        switch self.unpacked {
        case .view(let view):
            return [view]
        case .array(let array):
            let views: [_View] = array.mapToViews(
                onChange: {
                    onChange($0, $1)
                }
            )
            return views
        case .if(let nIf):
            nIf.strongify()
            let nViews: [NView] = nIf.ifViews
            let views: [_View] = nViews.mapToViews(
                onChange: { (changeOffset: Int, changes: [NChange<_View>]) in
                    onChange(changeOffset, changes)
                }
            )
            nIf.weakify()
            
            nIf.onDataChange { (viewsBeforeMe: Int, changes: [NChange<NView>]) in
                let mappedChanges: [NChange<_View>] = changes.mapChanges(onChange: onChange)
                
                onChange(viewsBeforeMe, mappedChanges)
            }
            
            return views
        case .forEach(let nForEach):
            nForEach.strongify()
            let nViews: [NView] = nForEach.forEachViews
            let views: [_View] = nViews.mapToViews(
                onChange: { (changeOffset: Int, changes: [NChange<_View>]) in
                    let offset: Int = changeOffset + 0
                    
                    onChange(offset, changes)
                }
            )
            nForEach.weakify()
            
            nForEach.onDataChange { (viewsBeforeMe: Int, changes: [NChange<NView>]) in
                let mappedChanges: [NChange<_View>] = changes.mapChanges(onChange: onChange)
                
                onChange(viewsBeforeMe, mappedChanges)
            }
            
            return views
        case .otherObject(let object):
            let viewBody: _View = object.bodyWithPreparation()
            return [viewBody]
        case .other(let nView):
            let viewBody: _View = nView.bodyWithPreparation()
            return [viewBody]
        }
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
            case .remove(let at, let count, let animated):
                return .remove(at: at, count: count, animated: animated)
            case .keep(let views):
                return .keep(views: views.views(
                    onChange: onChange
                ))
            case .move(let from, let to, let views, let animated):
                return .move(from: from, to: to, views: views.views(
                    onChange: onChange
                ), animated: animated)
            case .insert(let at, let views, let animated):
                return .insert(at: at, views: views.views(
                    onChange: onChange
                ), animated: animated)
            }
        }
    }
}

#if DEBUG
@available(*, unavailable)
//@MainActor
//private func __WarningTest(bool: Bool) {
#Preview {
    let bool: Bool = true
    
    NViewPreview {
        NVStack {
            //        Optional(NColor(.red))
            
            if bool {
                NColor(.red)
            }
            
            if bool {
                NColor(.red)
            } else {
                NColor(.red)
            }
            
            if bool {
                NColor(.red)
            } else if bool {
                NColor(.red)
            } else {
                NColor(.red)
            }
            
            for _ in 0...1 {
                NColor(.red)
            }
            
            if #available(macOS 10.15, iOS 13.0, *) {
                NColor(.red)
            }
            
            if #available(macOS 10.15, iOS 13.0, *) {
                NColor(.red)
            } else {
                NColor(.red)
            }
        }
    }
}
#endif
