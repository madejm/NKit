import Foundation

extension NBinding {
    public static func combine(
        _ one: NBinding<Bool>,
        _ two: NBinding<Bool>
    ) -> NBinding<Bool> {
        .combine(
            one,
            two,
            up: {
                $0 && $1
            },
            down: {
                ($0, $0)
            }
        )
    }
    
    public static func combine<T>(
        _ one: NBinding<T>,
        _ two: NBinding<T>,
        up: @escaping @MainActor (T, T) -> Value,
        down: @escaping @MainActor (Value) -> (T, T)
    ) -> NBinding<Value> {
        let newBinding: NBinding<Value> = .init(
            get: {
                up(one.wrappedValue, two.wrappedValue)
            },
            set: {
                let newValue = down($0)
                one.wrappedValue = newValue.0
                two.wrappedValue = newValue.1
            }
        )
        
        one.onChange { newValue in
            newBinding.signalChange(up(newValue, two.wrappedValue))
        }
        two.onChange { newValue in
            newBinding.signalChange(up(one.wrappedValue, newValue))
        }
        
        return newBinding
    }
}
