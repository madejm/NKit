//
//  NView+.swift
//  NKit
//
//  Created by Mejdej on 12/08/2025.
//


extension Array where Element == NView {
    @MainActor
    internal var viewsCount: Int {
        self.reduce(into: 0) {
            $0 += $1.viewsCount
        }
    }
    
    @MainActor
    internal func viewCount(upTo index: Int) -> Int {
        guard index > 0 else {
            return 0
        }
        
        var sum: Int = 0
        
        for i in 0..<index {
            let view: NView = self[i]
            sum += view.viewsCount
        }
        
        return sum
    }
    
    @MainActor
    internal func VIEW_PRINT(upTo index: Int, indent: Int) -> String {
        guard index > 0 else {
            return ""
        }
        
        var res = ""
        res += indent.indent()
        res += "< upTo \(index)\n"
        
        for i in 0..<index {
            let view: NView = self[i]
            res += view.VIEW_PRINT(indent: indent + 1)
        }
        
        res += indent.indent()
        res += ">\n"
        
        return res
    }
}

extension Int {
    func indent() -> String {
        var res = ""
        for i in 0..<self {
            res += "    "
        }
        return res
    }
}
