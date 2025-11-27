//
//  UserInterfaceSizeClass.swift
//  NKit
//
//  Created by Mejdej on 27/11/2025.
//

#if canImport(UIKit)
import UIKit
#endif

public enum UserInterfaceSizeClass: Sendable, Equatable {

    /// The compact size class.
    case compact

    /// The regular size class.
    case regular
    
    #if canImport(UIKit)
    public init(_ sizeClass: UIUserInterfaceSizeClass) {
        switch sizeClass {
        case .compact:
            self = .compact
        case .regular:
            self = .regular
        case .unspecified:
            self = .regular
        @unknown default:
            self = .regular
        }
    }
    #endif
}

internal struct VerticalSizeClassEnvironmentKey: NEnvironmentKey {
    internal static let defaultValue: UserInterfaceSizeClass = .regular
}

internal struct HorizontalSizeClassEnvironmentKey: NEnvironmentKey {
    internal static let defaultValue: UserInterfaceSizeClass = .regular
}

extension NEnvironmentValues {
    public var verticalSizeClass: UserInterfaceSizeClass {
        get { self[VerticalSizeClassEnvironmentKey.self] }
        set { self[VerticalSizeClassEnvironmentKey.self] = newValue }
    }
    
    public var horizontalSizeClass: UserInterfaceSizeClass {
        get { self[HorizontalSizeClassEnvironmentKey.self] }
        set { self[HorizontalSizeClassEnvironmentKey.self] = newValue }
    }
}
