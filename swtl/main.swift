//
//  main-swtl.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/18/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

if Process.arguments.count < 2 {
  print("Usage: \(Process.arguments[0]) [filename]")
  exit(1)
}

let output = Process.arguments[1] + ".swift"
let code = Template().parse(Process.arguments[1])

try code?.writeToFile(output, atomically: true, encoding: NSUTF8StringEncoding)