import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
#if DEBUG
import SwiftUI
#endif

extension _View {
    public func hidden(_ hidden: Bool) -> Self {
        self.hidden(NGet.constant(hidden))
    }
    
    public func hidden(_ hiddenBinding: NBinding<Bool>) -> Self {
        self.hidden(hiddenBinding.get)
    }
    
    public func hidden(_ hiddenBinding: NGet<Bool>) -> Self {
        let initialValue: Bool = hiddenBinding.wrappedValue
        
//        OperationQueue.main.addOperation { [weak self] in
        Task { @MainActor [weak self] in
            self?.firstViewInStack?.isHidden = initialValue
        }
        
        hiddenBinding.onChange { [weak self] newValue in
            self?.firstViewInStack?.isHidden = newValue
        }
        
        return self
    }
    
    internal var firstViewInStack: _View? {
        guard let parent: _View = self.superview else {
            print_canvas("nil \(type(of: self))")
            return nil
        }
        
        if let parentOverlay = parent as? NOverlay,
           parentOverlay.mainView != self {
            print_canvas("NOverlay \(type(of: self))")
            return self
        }
        guard let parentStack = parent as? _Stack else {
            print_canvas("parent.firstViewInStack \(type(of: self)) -> ", terminator: "")
            return parent.firstViewInStack
        }
        guard parentStack.arrangedSubviews.count > 1 else {
            print_canvas("parent.firstViewInStack count \(parentStack.arrangedSubviews.count) \(type(of: self))  -> ", terminator: "")
            return parent.firstViewInStack
        }
        print("self \(type(of: self))")
        return self
    }
}

#if DEBUG
@available(macOS 14.0, iOS 17.0, *)
#Preview {
    @Previewable @NState var hidden1: Bool = false
    @Previewable @State var hidden2: Bool = false
    
    HStack {
        VStack {
            Toggle("", isOn: $hidden2)
                .toggleStyle(.switch)
            
            if !hidden2 {
                Color.green
                    .frame(width: 100, height: 100)
            }
            
            Color(.white)
                .frame(height: 4)
            
            if !hidden2 {
                Color.green
                    .overlay{
                        Color.red
                            .padding(20)
                    }
                    .frame(width: 100, height: 100)
            }
            
            Color.white
                .frame(height: 4)
            
            if !hidden2 {
                Color.green
                    .overlay{
                        Color.red
                            .padding(20)
                    }
                    .frame(width: 100, height: 100)
            }
            
            Color.clear
        }
        .background(.gray)
        .padding(20)
        
        NViewPreview {
            NVStack(hugging: .resize) {
                NSwitch($hidden1)
                
                NColor(.green)
                    .frame(width: 100, height: 100)
                    .hidden($hidden1)
                
                NColor(.white)
                    .frame(height: 4)
                
                NColor(.green)
                    .overlay{
                        NColor(.red)
                            .padding(20)
                    }
                    .frame(width: 100, height: 100)
                    .hidden($hidden1)
                
                NColor(.white)
                    .frame(height: 4)
                
                NColor(.green)
                    .hidden($hidden1)
                    .overlay{
                        NColor(.red)
                            .padding(20)
                    }
                    .frame(width: 100, height: 100)
                
                NColor(.clear)
            }
            .background(.gray)
            .padding(20)
        }
    }
}
#endif
