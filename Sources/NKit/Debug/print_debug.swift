//
//  PrintOnDebug.swift
//  NKit
//
//  Created by Mejdej on 13/08/2025.
//

import Foundation

#if DEBUG
nonisolated(unsafe) public var NKitDebugLoggingEnabled: Bool = false
#endif

package func print_debug(
    _ message1: @autoclosure () -> Any
) {
    #if DEBUG
    if NKitDebugLoggingEnabled {
        print(message1())
    }
    #endif
}

package func print_debug(
    _ message1: @autoclosure () -> Any,
    _ message2: @autoclosure () -> Any
) {
    #if DEBUG
    if NKitDebugLoggingEnabled {
        print(message1(), message2())
    }
    #endif
}

package func print_debug(
    _ message1: @autoclosure () -> Any,
    _ message2: @autoclosure () -> Any,
    _ message3: @autoclosure () -> Any
) {
    #if DEBUG
    if NKitDebugLoggingEnabled {
        print(message1(), message2(), message3())
    }
    #endif
}

package func print_debug(
    _ message1: @autoclosure () -> Any,
    _ message2: @autoclosure () -> Any,
    _ message3: @autoclosure () -> Any,
    _ message4: @autoclosure () -> Any
) {
    #if DEBUG
    if NKitDebugLoggingEnabled {
        print(message1(), message2(), message3(), message4())
    }
    #endif
}

package func print_debug(
    _ message1: @autoclosure () -> Any,
    _ message2: @autoclosure () -> Any,
    _ message3: @autoclosure () -> Any,
    _ message4: @autoclosure () -> Any,
    _ message5: @autoclosure () -> Any
) {
    #if DEBUG
    if NKitDebugLoggingEnabled {
        print(message1(), message2(), message3(), message4(), message5())
    }
    #endif
}

package func print_canvas(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
        print(items.map { "\($0)" }.joined(separator: separator), terminator: terminator)
    }
    #endif
}
