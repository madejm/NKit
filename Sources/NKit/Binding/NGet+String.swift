import Foundation

extension NGet: @MainActor ExpressibleByUnicodeScalarLiteral where Value == String {
}

extension NGet: @MainActor ExpressibleByExtendedGraphemeClusterLiteral where Value == String {
}

extension NGet: @MainActor ExpressibleByStringLiteral where Value == String {
    public convenience init(stringLiteral value: String) {
        self.init(get: {
            value
        })
    }
}

extension NGet: @MainActor ExpressibleByStringInterpolation where Value == String {
    public convenience init(stringInterpolation: StringInterpolation) {
        self.init(get: {
            stringInterpolation.output()
        })
        
        stringInterpolation.components.registerOnChanges(self)
    }
    
    @MainActor
    public struct StringInterpolation: @MainActor StringInterpolationProtocol {
        @MainActor
        fileprivate final class Components {
            enum Component {
                case string(String)
                case get(any NAnyGet<String>)
            }
            
            private var storage: [Component] = []
            
            func registerOnChanges(_ newGetter: NGet<String>) {
                for component in self.storage {
                    switch component {
                    case .string:
                        break
                    case .get(let anyGet):
                        anyGet.onChange { [weak self] _ in
                            guard let self else {
                                return
                            }
                            newGetter.signalChange(self.joined())
                        }
                    }
                }
            }
            
            func append(_ value: String) {
                storage.append(.string(value))
            }
            
            func append(_ value: any NAnyGet<String>) {
                storage.append(.get(value))
            }
            
            func joined() -> String {
                storage.reduce("") { result, component in
                    switch component {
                    case .string(let string):
                        return result + string
                    case .get(let get):
                        return result + get.wrappedValue
                    }
                }
            }
        }
        
        fileprivate let components: Components
        fileprivate let output: () -> String
        
        public init(literalCapacity: Int, interpolationCount: Int) {
            let components: Components = .init()
            
            self.components = components
            self.output = {
                components.joined()
            }
        }
        
        public mutating func appendLiteral(_ literal: String) {
            components.append(literal)
        }
        
        public mutating func appendInterpolation(_ value: any NAnyGet<String>) {
            components.append(value)
        }
        
        public mutating func appendInterpolation<T>(_ value: any NAnyGet<T>) where T: Equatable {
            components.append(value.map(up: {
                String(describing: $0)
            }))
        }
        
        // Optional: support other types too
        public mutating func appendInterpolation<T>(_ value: T) {
            components.append(String(describing: value))
        }
    }
}
