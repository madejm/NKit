import Foundation
import Combine
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension _View {
    public func onChange<Value>(
        of binding: NBinding<Value>,
        perform action: @escaping @MainActor (Value) -> Void
    ) -> Self {
        binding
            .onChange {
                action($0)
            }
        
        return self
    }
    
    public func onChange<Value>(
        of state: NState<Value>,
        perform action: @escaping @MainActor (Value) -> Void
    ) -> Self {
        state
            .projectedValue
            .onChange {
                action($0)
            }
        
        return self
    }
    
    public func onChange(
        set closureProperty: inout (() -> Void)?,
        perform action: @escaping @MainActor () -> Void
    ) -> Self {
        closureProperty = action
        
        return self
    }
    
    public func onReceive<P>(
        _ publisher: P,
        perform action: @escaping @MainActor (P.Output) -> Void
    ) -> Self where P : Publisher, P.Failure == Never {
        publisher
            .sink {
                action($0)
            }
            .store(in: &self.cancellables)
        
        return self
    }
}
