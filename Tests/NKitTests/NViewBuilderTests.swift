//
//  NViewBuilderTests.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

import Testing
@testable import NKit

@Suite("NViewBuilderTests")
@MainActor
struct NViewBuilderTests {
    @Test func empty() {
        @NViewBuilder func builder() -> [NView] {
        }
        
        let result: [NView] = builder()
        #expect(result.count == 0)
    }
    
    @Test func simple() {
        @NViewBuilder func builder() -> [NView] {
            NColor.clear
            NColor.clear
        }
        
        let result: [NView] = builder().flatten()
        #expect(result.count == 2)
    }
    
    @Test func array() {
        @NViewBuilder func builder() -> [NView] {
            NColor.clear
            [NColor.clear, NColor.clear]
        }
        
        let result: [NView] = builder().flatten()
        #expect(result.count == 3)
    }
    
    @Test func withIfTrue() {
        @NViewBuilder func builder() -> [NView] {
            NColor.clear
            if true {
                NColor.clear
            }
        }
        
        let result: [NView] = builder().flatten()
        #expect(result.count == 2)
    }
    
    @Test func withIfFalse() {
        @NViewBuilder func builder() -> [NView] {
            NColor.clear
            if false {
                NColor.clear
            }
        }
        
        let result: [NView] = builder().flatten()
        print("")
        #expect(result.count == 1)
    }
    
    @Test func withIfElseTrue() {
        @NViewBuilder func builder() -> [NView] {
            NColor.clear
            if true {
                NColor.clear
                NColor.clear
            } else {
                NColor.clear
            }
        }
        
        let result: [NView] = builder().flatten()
        print("")
        #expect(result.count == 3)
    }
    
    @Test func withIfElseFalse() {
        @NViewBuilder func builder() -> [NView] {
            NColor.clear
            if false {
                NColor.clear
                NColor.clear
            } else {
                NColor.clear
            }
        }
        
        let result: [NView] = builder().flatten()
        print("")
        #expect(result.count == 2)
    }
    
    @Test func withForIn() {
        @NViewBuilder func builder() -> [NView] {
            for _ in 1...3 {
                NColor.clear
            }
        }
        
        let result: [NView] = builder().flatten()
        print("")
        #expect(result.count == 3)
    }
    
    @Test func withAvailable() {
        @NViewBuilder func builder() -> [NView] {
            if #available(macOS 1.0, iOS 1.0, *) {
                NColor.mac1
            }
            if #available(macOS 100.0, iOS 100.0, *) {
                NColor.mac100
                NColor.mac100
                NColor.mac100
                NColor.mac100
            } else {
                NColor.mac1
                NColor.mac1
            }
        }
        
        let result: [NView] = builder().flatten()
        #expect(result.count == 3)
    }
}

extension NColor {
    static var clear: NColor {
        .init(.clear)
    }
    
    @available(macOS 1.0, iOS 1.0, *)
    static var mac1: NColor {
        .init(.blue)
    }
    
    @available(macOS 100.0, iOS 100.0, *)
    static var mac100: NColor {
        .init(.blue)
    }
}

extension Array where Element == NView {
    func flatten() -> [NView] {
        var result: [NView] = []
        
        for element in self {
            if let view = element as? _View {
                result.append(view)
            } else if let array = element as? [NView] {
                result.append(contentsOf: array)
            } else {
                fatalError()
            }
        }
        
        return result
    }
}
