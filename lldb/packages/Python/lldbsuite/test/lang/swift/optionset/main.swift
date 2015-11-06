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
import AppKit

struct Options : OptionSetType {
  let rawValue: Int
}

func main() {
  var user_option = Options(rawValue: 123456)
  var sdk_option_exhaustive: NSBinarySearchingOptions = [.FirstEqual, .InsertionIndex]
  var sdk_option_nonexhaustive = NSBinarySearchingOptions(rawValue: 257)
  var sdk_option_nonevalid = NSBinarySearchingOptions(rawValue: 12)
  print("break here and do test") //%self.expect('frame variable user_option', substrs=['rawValue = 123456'])
  //%self.expect('expression user_option', substrs=['rawValue = 123456'])
  //%self.expect('frame variable sdk_option_exhaustive', substrs=['[.FirstEqual, .InsertionIndex]'])
  //%self.expect('expression sdk_option_exhaustive', substrs=['[.FirstEqual, .InsertionIndex]'])
  //%self.expect('frame variable sdk_option_nonexhaustive', substrs=['[.FirstEqual, 0x1]'])
  //%self.expect('expression sdk_option_nonexhaustive', substrs=['[.FirstEqual, 0x1]'])
  //%self.expect('frame variable sdk_option_nonevalid', substrs=['rawValue = 12'])
  //%self.expect('expression sdk_option_nonevalid', substrs=['rawValue = 12'])
}

main()
