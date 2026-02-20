//
//  ReleaseChecker.swift
//  NKit
//
//  Created by Mateusz Madej on 05/08/2025.
//

import os.log

internal final class ReleaseChecker: @unchecked Sendable {
    private weak var object: AnyObject?
    private let name: String
    private var releaseExpected: Bool = false
    private var releaseConfirmed: Bool = false
    
    @available(macOS 11.0, iOS 14.0, *)
    private static let logger: Logger = Logger.init(subsystem: "NKit", category: "ReleaseChecker")
    
    internal init(_ object: AnyObject, name: String) {
        self.object = object
        self.name = name
    }
    
    internal func expect() {
        self.releaseExpected = true
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
            guard self.releaseExpected else {
                return
            }
            if self.object == nil, !self.releaseConfirmed {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Self.logger.debug("🪤 \(self.name) released correctly ✅")
                } else {
                    print("🪤 \(self.name) released correctly ✅")
                }
            } else if self.object != nil {
                if #available(macOS 11.0, iOS 14.0, *) {
                    Self.logger.critical("🪤 \(self.name) was not released! ❌")
                } else {
                    print("🪤 \(self.name) was not released! ❌")
                }
            }
        }
    }
    
    internal func cancelExpectation() {
        self.releaseExpected = false
    }
    
    internal func confirm() {
        self.releaseConfirmed = true
        
        if #available(macOS 11.0, iOS 14.0, *) {
            Self.logger.debug("🪤 \(self.name) release confirmed ✅")
        } else {
            print("🪤 \(self.name) release confirmed ✅")
        }
    }
    
    deinit {
        guard self.object != nil else {
            return
        }
        
        if #available(macOS 11.0, iOS 14.0, *) {
            Self.logger.warning("🪤 ReleaseChecker for \(self.name) released before the object ⚠️")
        } else {
            print("🪤 ReleaseChecker for \(self.name) released before the object ⚠️")
        }
    }
}
