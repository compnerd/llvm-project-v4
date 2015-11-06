// main.swift
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
// -----------------------------------------------------------------------------
struct DefaultMirror {
  var a = 12
  var b = 24
}

struct CustomMirror : CustomReflectable {
  var a = 12
  var b = 24
  
  func customMirror() -> Mirror {
    return Mirror(self, children: ["c" : a + b])
  }
}

struct CustomSummary : CustomStringConvertible, CustomDebugStringConvertible {
  var a = 12
  var b = 24
  
  var description: String { return "CustomStringConvertible" }
  var debugDescription: String { return "CustomDebugStringConvertible" }
}

func main() {
  var dm = DefaultMirror()
  var cm = CustomMirror()
  var cs = CustomSummary()
  print("yay I am done!") //% self.expect("po dm", substrs=['a', 'b', '12', '24'])
  //% self.expect("po cm", substrs=['c', '36'])
  //% self.expect("po cm", substrs=['12', '24'], matching=False)
  //% self.expect("po cs", substrs=['CustomDebugStringConvertible'])
  //% self.expect("po cs", substrs=['CustomStringConvertible'], matching=False)
  //% self.expect("po cs", substrs=['a', '12', 'b', '24'])
  //% self.expect("po (12,24,36,48)", substrs=['12', '24', '36', '48'])
  //% self.expect("po [dm as Any,cm as Any,48 as Any]", substrs=['12', '24', '36', '48'])
}

main()
