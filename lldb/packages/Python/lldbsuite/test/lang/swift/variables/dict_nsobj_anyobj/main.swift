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
import Cocoa

func main() {
  var d1: Dictionary<Int,Int> = [1:1,2:2,3:3,4:4]
  var d2: Dictionary<NSObject,AnyObject> = [1:1,2:2,3:3,4:4]
  print("break here")
}

main()
