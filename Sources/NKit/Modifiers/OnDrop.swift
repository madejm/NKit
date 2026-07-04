import UniformTypeIdentifiers

#if canImport(AppKit)
import AppKit
#endif

#if canImport(AppKit)
extension NSView {
    public func onDrop(
        of supportedContentTypes: [NSPasteboard.PasteboardType],
        isTargeted: NBinding<Bool>? = nil,
        perform action: @escaping ([URL]) -> Bool
    ) -> _View {
        DropDestinationView(
            newTypes: supportedContentTypes,
            isTargeted: isTargeted,
            content: self,
            action: { (pasteboard: NSPasteboard) in
                guard let urls: [URL] = pasteboard.readObjects(
                    forClasses: [NSURL.self],
                    options: [.urlReadingFileURLsOnly: true]
                ) as? [URL] else {
                    return false
                }
                return action(urls)
            }
        )
    }
    
    @available(macOS 11.0, *)
    public func onDrop(
        of supportedContentTypes: [UTType],
        isTargeted: NBinding<Bool>? = nil,
        perform action: @escaping ([NSItemProvider]) -> Bool
    ) -> _View {
        let newTypes: [NSPasteboard.PasteboardType] = supportedContentTypes
            .map {
                NSPasteboard.PasteboardType(rawValue: $0.identifier)
            }
        
        return DropDestinationView(
            newTypes: newTypes,
            isTargeted: isTargeted,
            content: self,
            action: { (pasteboard: NSPasteboard) in
                let providers: [NSItemProvider] = pasteboard.itemProviders
                return action(providers)
            }
        )
    }
}
#endif

#if canImport(AppKit)
private final class DropDestinationView: BaseView {
    
    private let isTargeted: NBinding<Bool>?
    private let action: (NSPasteboard) -> Bool
    
    init(
        newTypes: [NSPasteboard.PasteboardType],
        isTargeted: NBinding<Bool>?,
        content: _View,
        action: @escaping (NSPasteboard) -> Bool
    ) {
        self.isTargeted = isTargeted
        self.action = action
        
        super.init()
        self.addSubviewAutomatically(content)
        registerForDraggedTypes(newTypes)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isTargeted?.wrappedValue = true
        
//        let pasteboard = sender.draggingPasteboard
//
//        guard let classes = [NSURL.self] as [Any]?,
//              pasteboard.canReadObject(forClasses: classes,
//                                       options: [.urlReadingFileURLsOnly: true]) else {
//            return []
//        }
        
//        let pb = sender.draggingPasteboard
//
//        guard let urls = pb.readObjects(
//            forClasses: [NSURL.self],
//            options: [.urlReadingFileURLsOnly: true]
//        ) as? [URL] else {
//            return []
//        }
//
//        guard urls.allSatisfy({ $0.pathExtension.lowercased() == "png" }) else {
//            return []
//        }
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isTargeted?.wrappedValue = false
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        isTargeted?.wrappedValue = false
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard: NSPasteboard = sender.draggingPasteboard
        
        return action(pasteboard)
    }
}
#endif

#if canImport(AppKit)
private extension NSPasteboard {
    @available(macOS 11.0, *)
    var itemProviders: [NSItemProvider] {
        var providers: [NSItemProvider] = []

        for pasteboardType in self.types ?? [] {
            guard let utType = UTType(pasteboardType.rawValue),
                  let data = self.data(forType: pasteboardType)
            else {
                continue
            }
            let provider = NSItemProvider()

            provider.registerDataRepresentation(
                forTypeIdentifier: utType.identifier,
                visibility: .all
            ) { completion in
                completion(data, nil)
                return nil
            }
            providers.append(provider)
        }

        return providers
    }
}
#endif
