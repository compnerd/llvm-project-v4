import CModule

func use<T>(_ t: T) {}

let pureSwift = 42
let point = Point(x: 1, y: 2)
let enumerator = yellow
use(pureSwift) // break here
use(point)
