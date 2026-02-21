@MainActor
internal protocol NCacheable {
    func weakify()
    func strongify()
    func clear()
}
