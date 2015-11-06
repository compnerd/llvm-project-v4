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
import Foundation

func main() {
	var dic = NSMutableDictionary()
	dic.setObject(3 as NSNumber, forKey: "foo" as NSString)
	dic.setObject("3" as NSString, forKey: NSURL(string: "http://www.google.com")!)
	print("break here")
}

main()
