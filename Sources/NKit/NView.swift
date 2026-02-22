import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Abstraction over a view or collection of views (in `ForEach`)
/// Think as of SwiftUI's `View`
@MainActor
public protocol NView {
    var body: _View { get }
}

extension NView {
    internal func bodyWithPreparation() -> _View {
        let body = self.body
        
        let releaseChecker = ReleaseChecker()
        releaseChecker.prepare(
            body,
            customName: {
                if self is (AnyObject & NView) {
                    return String(reflecting: self)
                } else {
                    return "\(String(reflecting: type(of: self)))<\(String(reflecting: body))>"
                }
            }()
        )
        body[associatedId: .releaseChecker] = releaseChecker
        
        body.viewDidMoveToSuperviewPublisher
            .sink {
                releaseChecker.cancelExpectation()
            }
            .store(in: &body.cancellables)
        
        body.removeFromSuperviewPublisher
            .sink {
                releaseChecker.expect()
            }
            .store(in: &body.cancellables)
        
        return body
    }
}

extension _View: NView {
    public var body: _View {
        self
    }
}

extension Array: NView where Element == NView {
    public var body: _View {
        fatalError("Array does not produce a body!")
    }
}

internal enum NViewUnpacked {
    case view(_View)
    case array([NView])
    case forEach(NForEach)
    case `if`(NIf)
    case otherObject(NView & AnyObject)
    case other(NView)
}

extension NView {
    
    internal var unpacked: NViewUnpacked {
        if let array = self as? [NView] {
            return .array(array)
        } else if let view = self as? _View {
            return .view(view)
        } else if let forEach = self as? NForEach {
            return .forEach(forEach)
        } else if let anIf = self as? NIf {
            return .if(anIf)
        } else if let object = self as? (NView & AnyObject) {
            return .otherObject(object)
        } else {
            return .other(self)
        }
    }
}
