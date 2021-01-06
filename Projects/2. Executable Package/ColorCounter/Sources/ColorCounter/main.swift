import Foundation
import CoolExtensionsLib
import ColorizeSwift

let colors: [TerminalColor] = [.red3, .green3, .cyan2, .yellow3]
for i in 0 ... 10 {
    print(i.string.foregroundColor(colors.randomElement()!))
}
