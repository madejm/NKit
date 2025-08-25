//
//  NChange.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//

internal enum NChange<View> {
    case remove(at: StackIndex, count: Int, animated: Bool)
    
    case keep(views: [View])
    case move(from: StackIndex, to: StackIndex, views: [View], animated: Bool)
    case insert(at: StackIndex, views: [View], animated: Bool)
}

extension NChange {
    internal var views: [View]? {
        switch self {
        case .remove(_, _, _):
            return nil
        case .keep(let views):
            return views
        case .move(_, _, let views, _):
            return views
        case .insert(_, let views, _):
            return views
        }
    }
}
