//
//  NForEachEngine.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

@MainActor
internal protocol NForEachEngine {
    func setOwner(_ owner: AnyNForEach)
    
    func setNForEachParent(_ parent: NView)
    
    var viewsCountInCache: Int { get }
    func viewsCountInCache(until end: AnyNForEach) -> (count: Int, stop: Bool)
    
    var forEachViews: [NView] { get }
    
    func onDataChange(
        changed: @escaping (_ viewsBeforeMe: Int, _ changes: [NChange<NView>]) -> Void
    )
    
    func clearCache()
}
