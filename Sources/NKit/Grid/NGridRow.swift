//
//  File.swift
//  
//
//  Created by Mateusz Madej on 16/09/2024.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public final class NGridRow: NHStack {
    @NEnvironment(\.gridParent) private var gridParent
    private var gridConstraints: [NSLayoutConstraint] = []
    
    public override init(
        alignment: Alignment = .center,
        spacing: CGFloat = 0,
        stretching: Stretching = .none,
        @NViewBuilder _ content: @escaping ViewCreator
    ) {
        super.init(
            alignment: alignment,
            spacing: spacing,
            stretching: stretching,
            content
        )
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        self.stack.arrangedSubviews
            .forEach {
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
                $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            }
        
        self.gridConstraints
            .forEach {
                $0.isActive = false
            }
        
        self.gridConstraints = self
            .stack
            .arrangedSubviews
            .enumerated()
            .compactMap() { index, view in
                self.gridParent?.equalSize(width: true, at: index, with: view)
            }
    }
}
