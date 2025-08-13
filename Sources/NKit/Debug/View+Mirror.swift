//
//  View+Mirror.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

#if DEBUG
extension _View {
    internal var mirrorDescription: String {
        let mirror = Mirror(reflecting: self)
        let children: [String] = mirror
            .children
            .map {
                if let label = $0.label {
                    return "\(label): \($0.value)"
                } else {
                    return "\($0.value)"
                }
            }
        
        return "\(mirror.subjectType)(\(children.joined(separator: ", ")))"
    }
}
#endif
