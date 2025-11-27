//
//  File.swift
//  
//
//  Created by Mateusz Madej on 22/03/2024.
//

import Foundation
#if canImport(AppKit)
import AppKit

extension NSViewController {
    public func windowController(
        title: String?,
        frameAutosaveName: String? = nil,
        onClose: ((NSWindowController?) -> Void)? = nil
    ) -> NSWindowController {
        let window = ClosableWindow(contentViewController: self)
        if let title {
            window.title = title
        }
        window.collectionBehavior = .fullScreenAuxiliary
        
        let wc = NSWindowController(window: window)
        if let windowFrameAutosaveName = frameAutosaveName ?? title {
            wc.windowFrameAutosaveName = windowFrameAutosaveName
        }
        
        window.onClose = { [weak wc, weak self] in
            onClose?(wc)
            
            if let baseController = self as? NBaseViewController {
                baseController.windowDidClose()
            }
        }
        
        return wc
    }
}

extension NValue where Value == NSWindowController? {
    @MainActor
    public func show(
        _ controller: NBaseViewController,
        title: String?,
        frameAutosaveName: String? = nil
    ) {
        var initialFrame: CGRect?
        
        if case let .some(window) = self.wrappedValue {
            initialFrame = window.window?.frame
            
            window.close()
        }
        
        let windowController: NSWindowController = controller.windowController(
            title: title,
            frameAutosaveName: frameAutosaveName,
            onClose: { [weak self] wc in
                guard self?.wrappedValue == wc else {
                    return
                }
                self?.wrappedValue = nil
            }
        )
        
        if let initialFrame = initialFrame, var frame = windowController.window?.frame {
            frame.origin = initialFrame.origin
            windowController.window?.setFrame(initialFrame, display: false)
        }
        
        windowController.showWindow(self)
        
        self.wrappedValue = windowController
    }
}

private final class ClosableWindow: NSWindow {
    var onClose: (() -> Void)?
    
    override func close() {
        super.close()
        
        onClose?()
    }
}
#endif
