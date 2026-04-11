import Combine

extension Publisher where Output: Equatable {
    public func removeDuplicates(initial: Output) -> AnyPublisher<Output, Failure> {
        scan((previous: initial, current: initial)) { state, newValue in
            (previous: state.current, current: newValue)
        }
        .filter { $0.previous != $0.current }
        .map(\.current)
        .eraseToAnyPublisher()
    }
}
