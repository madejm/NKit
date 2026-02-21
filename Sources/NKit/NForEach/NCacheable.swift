
internal protocol NCacheable {
    
    nonisolated var releaseChecker: ReleaseChecker { get }
    
    @MainActor
    func weakify()
    
    @MainActor
    func strongify()
    
    @MainActor
    func clear()
}
