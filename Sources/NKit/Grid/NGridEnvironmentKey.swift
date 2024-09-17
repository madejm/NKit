//
//  File.swift
//  
//
//  Created by Mateusz Madej on 16/09/2024.
//

import Foundation

internal struct NGridEnvironmentKey: NEnvironmentKey {
    internal static let defaultValue: NGrid? = nil
}

extension NEnvironmentValues {
    internal var gridParent: NGrid? {
        get { self[NGridEnvironmentKey.self] }
        set { self[NGridEnvironmentKey.self] = newValue }
    }
}
