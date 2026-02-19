import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@MainActor
public protocol NControlledView: NView {
    var body: _View { get }
}

public protocol NModelControlledView: NControlledView {
    associatedtype Model
    
    var model: Model { get }
    
    func body(_ model: @escaping () -> Model) -> _View
}

extension NModelControlledView where Model: AnyObject {
    public typealias GetModel = () -> Model
    
    public var body: _View {
        body { [unowned model] in
            model
        }
    }
    
    public func body(_ model: @escaping () -> Model) -> _View {
        body
    }
    
    @NViewBuilder
    public func withModel(
        @NViewBuilder _ build: (@escaping GetModel) -> [NView]
    ) -> [NView] {
        build { [unowned model] in
            model
        }
    }
    
    public func withModel(
        _ build: (@escaping GetModel) -> _View
    ) -> _View {
        build { [unowned model] in
            model
        }
    }
}
