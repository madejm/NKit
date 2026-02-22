//
//  ReleaseChecker.swift
//  NKit
//
//  Created by Mateusz Madej on 05/08/2025.
//

import os.log

internal final class ReleaseChecker: @unchecked Sendable {
    private final class Expectation: @unchecked Sendable {
        private var expectation: (() -> Void)?
        
        init(expectation: @escaping () -> Void) {
            self.expectation = expectation
            
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.expectation?()
            }
        }
        
        func cancel() {
            self.expectation = nil
        }
    }
    
    private let onlyImportant: Bool
    private weak var object: AnyObject?
    private var name: String?
    private var releaseExpected: Bool = false
    private var releaseConfirmed: Bool = false
    private var expectation: Expectation?
    
    @available(macOS 11.0, iOS 14.0, *)
    private static let logger: Logger = Logger.init(subsystem: "NKit", category: "ReleaseChecker")
    
    internal init(
        onlyImportant: Bool = false
    ) {
        self.onlyImportant = onlyImportant
    }
    
    internal func prepare(
        _ object: AnyObject,
        customName: String? = nil
    ) {
        if let currentName = self.name {
            if #available(macOS 11.0, iOS 14.0, *) {
                Self.logger.critical("🪤 Release checker is already prepared for \(currentName) ‼️")
            } else {
                print("🪤 Release checker is already prepared for \(currentName) ‼️")
            }
            return
        }
        self.object = object
        self.name = customName ?? String(reflecting: object)
    }
    
    internal func expect(
        file: StaticString = #fileID
    ) {
        guard let name else {
            if #available(macOS 11.0, iOS 14.0, *) {
                Self.logger.critical("🪤 Cannot expect, release checker is not prepared‼️ Called from: \(file)")
            } else {
                print("🪤 Cannot expect, release checker is not prepared‼️ Called from: \(file)")
            }
            return
        }
        guard !self.releaseExpected else {
            return
        }
        self.releaseExpected = true
        
        self.expectation = Expectation {
            self.expectation = nil
            guard self.releaseExpected else {
                return
            }
            if self.object == nil, !self.releaseConfirmed {
                if !self.onlyImportant {
                    if #available(macOS 11.0, iOS 14.0, *) {
                        Self.logger.debug("🪤 \(name) released correctly ✅")
                    } else {
                        print("🪤 \(name) released correctly ✅")
                    }
                }
            } else if self.object != nil {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Self.logger.critical("🪤 \(name) was not released! ❌")
                } else {
                    print("🪤 \(name) was not released! ❌")
                }
            }
        }
    }
    
    internal func cancelExpectation(
        file: StaticString = #fileID
    ) {
        guard self.name != nil else {
            if #available(macOS 11.0, iOS 14.0, *) {
                Self.logger.critical("🪤 Cannot cancel, release checker is not prepared‼️ Called from: \(file)")
            } else {
                print("🪤 Cannot cancel, release checker is not prepared‼️ Called from: \(file)")
            }
            return
        }
        self.releaseExpected = false
        self.expectation?.cancel()
        self.expectation = nil
    }
    
    internal func confirm(
        file: StaticString = #fileID
    ) {
        guard let name else {
            if #available(macOS 11.0, iOS 14.0, *) {
                Self.logger.critical("🪤 Cannot confirm, release checker is not prepared‼️ Called from: \(file)")
            } else {
                print("🪤 Cannot confirm, release checker is not prepared‼️ Called from: \(file)")
            }
            return
        }
        self.releaseConfirmed = true
        
        if !self.onlyImportant {
            if #available(macOS 11.0, iOS 14.0, *) {
                Self.logger.debug("🪤 \(name) release confirmed ✅")
            } else {
                print("🪤 \(name) release confirmed ✅")
            }
        }
    }
    
    deinit {
        guard let name else {
            if #available(macOS 11.0, iOS 14.0, *) {
                Self.logger.critical("🪤 Deinitalising a release checker that is not prepared‼️")
            } else {
                print("🪤 Deinitalising a release checker that is not prepared‼️")
            }
            return
        }
        guard self.object != nil else {
            return
        }
        
        if #available(macOS 11.0, iOS 14.0, *) {
            Self.logger.warning("🪤 ReleaseChecker for \(name) released before the object ⚠️")
        } else {
            print("🪤 ReleaseChecker for \(name) released before the object ⚠️")
        }
    }
}
