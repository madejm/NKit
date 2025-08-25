//
//  NIf.swift
//  NKit
//
//  Created by Mejdej on 25/08/2025.
//

@MainActor
public final class NIf: NView {
    private let binding: NGet<Bool>
    private let animateChanges: Bool
    private let ifTrue: () -> [NView]
    private let ifElse: () -> [NView]
    private var cachedView: CachedView?
    private /*unowned*/ var parent: NView?
    
    public init<T>(
        _ binding: NGet<T>,
        _ expression: @escaping (T, T) -> Bool,
        _ expectedResult: T,
        animateChanges: Bool = false,
        @NViewBuilder ifTrue: @escaping () -> [NView],
        @NViewBuilder else ifElse: @escaping () -> [NView] = { [] }
    ) {
        self.animateChanges = animateChanges
        self.ifTrue = ifTrue
        self.ifElse = ifElse
        self.binding = binding.map(
            up: {
                let result: Bool = expression($0, expectedResult)
                return result
            }
        )
    }
    
    public init(
        _ binding: NGet<Bool>,
        animateChanges: Bool = false,
        @NViewBuilder ifTrue: @escaping () -> [NView],
        @NViewBuilder else ifElse: @escaping () -> [NView] = { [] }
    ) {
        self.animateChanges = animateChanges
        self.ifTrue = ifTrue
        self.ifElse = ifElse
        self.binding = binding
    }
}

extension NIf {
    internal func setNIfParent(_ parent: NView) {
        self.parent = parent
    }
    
    internal func viewsCountInCache(until end: AnyObject) -> (count: Int, stop: Bool) {
        guard let cachedView else {
            return (0, false)
        }
        
        var count: Int = 0
        
        let result: (count: Int, stop: Bool) = cachedView.countViews(until: end)
        count += result.count
        
        if result.stop {
            return (count, true)
        }
        
        return (count, false)
    }
    
    internal var ifViews: [NView] {
//        guard let cachedViews else {
//            return []
//        }
        
        let views: [NView] = ifViewsFromCache()
            .compactMap {
                $0.views
            }
        
        return views
    }
    
    internal func ifViewsFromCache() -> [NChange<NView>] {
        var changes: [NChange<NView>] = []
        
        if let cachedView {
            changes.append(.remove(at: 0, count: cachedView.viewsCount, animated: animateChanges))
        }
        
        let newContents: [NView] = binding.wrappedValue ? ifTrue() : ifElse()
        
        if let parent {
            newContents.setParent(parent)
        }
        
        changes.append(.insert(at: 0, views: newContents, animated: animateChanges))
        
        cachedView = .init(
            hash: 0,
            views: newContents,
            isStrongified: true
        )
        
        return changes
    }
    
    internal func onDataChange(changed: @escaping (Int, [NChange<NView>]) -> Void) {
        binding.onChange { [weak self] (newValue: Bool) in
            guard let self else {
                return
            }
            
            let changes: [NChange<NView>] = self.ifViewsFromCache()
            let viewsBeforeMe: Int? = self.countViewsFromParentUntilYouMeetTheOwner()
            
            changed(viewsBeforeMe ?? 0, changes)
        }
    }
    
}

extension NIf {
    private func countViewsFromParentUntilYouMeetTheOwner() -> Int? {
        guard let parent else {
            return nil
        }
        return parent.countViews(until: self).count
    }
}
