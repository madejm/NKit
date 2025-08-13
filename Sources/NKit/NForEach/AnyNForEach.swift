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
    
    func isTheSameAs(_ other: AnyNForEach) -> Bool
    func setNForEachParent(_ parent: NView)
    func viewsCountInCache(until end: AnyNForEach) -> (count: Int, stop: Bool)
    func onDataChange(changed: @escaping (_ viewsBeforeMe: Int, _ changes: [NChange<NView>]) -> Void)
    func clearCache()
}
