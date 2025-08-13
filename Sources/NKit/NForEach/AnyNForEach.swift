//
//  AnyNForEach.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

@MainActor
internal protocol AnyNForEach: AnyObject {
    var forEachViews: [NView] { get }
    var viewsCountInCache: Int { get }
    
    func onDataChange(
        changed: @escaping (_ viewsBeforeMe: Int, _ changes: [NChange<NView>]) -> Void
//        changed: @escaping (_ changes: [NChange<NView>]) -> Void
    )
    
    func clearCache()
    
    var DEBUG_LABEL: String { get }
    var NONCACHABLE_DEBUG_CONTENT: [NView] { get }
    
    func VIEW_PRINT(indent: Int) -> String
    
    func setNForEachParent(_ parent: NView)
    
    func isTheSameAs(_ other: AnyNForEach) -> Bool
    func viewsCountInCache(until end: AnyNForEach) -> (count: Int, stop: Bool)
}
