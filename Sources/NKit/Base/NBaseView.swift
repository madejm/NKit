//
//  NBaseView.swift
//  NKit
//
//  Created by Mejdej on 17/02/2026.
//

open class NBaseView<View: NControlledView>: BaseView {
    public let view: View
    
    public init(_ view: View) {
        self.view = view
        
        super.init()
        
        self.prepare()
        
        self.addSubviewAutomatically(view.body)
    }
}
