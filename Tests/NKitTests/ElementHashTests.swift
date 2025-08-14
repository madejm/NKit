//
//  ElementHashTests.swift
//  NKit
//
//  Created by Mejdej on 14/08/2025.
//

import Testing
@testable import NKit

@Suite("ElementHashTests")
@MainActor
struct ElementHashTests {
    @Test func testHashes() {
        let hashable: Int = 123
        let hashableOptional: Int? = Optional.some(123)
        let hashableOptionalOptional: Int?? = Optional.some(Optional.some(123))
        
        let hashableHash: Int = hashable.hashValue
        let hashableOptionalHash: Int = hashableOptional.hashValue
        let hashableOptionalOptionalHash: Int = hashableOptionalOptional.hashValue
        
        /// This creates different hash values for `Optional` vs non-optional values
        #expect(hashableHash != hashableOptionalHash)
        #expect(hashableOptionalHash != hashableOptionalOptionalHash)
        #expect(hashableHash != hashableOptionalOptionalHash)
        
        let getHashable: NGet<Int> = .constant(123)
        let getHashableOptional: NGet<Int?> = .constant(Optional.some(123))
        let getHashableOptionalOptional: NGet<Int??> = .constant(Optional.some(Optional.some(123)))
        
        let getHashableHash: Int = getHashable.wrappedValue.hashValue
        let getHashableOptionalHash: Int = getHashableOptional.wrappedValue.hashValue
        let getHashableOptionalOptionalHash: Int = getHashableOptionalOptional.wrappedValue.hashValue
        
        /// Same here, hashes for wrapped values are different
        #expect(getHashableHash != getHashableOptionalHash)
        #expect(getHashableOptionalHash != getHashableOptionalOptionalHash)
        #expect(getHashableHash != getHashableOptionalOptionalHash)
        
        let getHashableOptionalFunction: Int? = elementHash(getHashableOptional)
        let getHashableOptionalOptionalFunction: Int? = elementHash(getHashableOptionalOptional)
        
        /// Here when using `elementHash(_:)` function the result is given for unwrapped value
        #expect(getHashableHash == getHashableOptionalFunction)
        #expect(getHashableOptionalFunction == getHashableOptionalOptionalFunction)
    }
}
