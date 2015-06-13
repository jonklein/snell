//
//  TestController.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Cocoa

class TestController: Controller {
  override func run() -> Response {
    let body = "\(content())<br/>\(params())<br/>\(debugInfo())"
    return Response(status: 200, body: body)
  }

  func content() -> String {
    return "Hello, world!!"
  }

  func params() -> String {
    return "<h2>Request Params</h2>" + "<br/>".join(self.request.params.keys.map{ "\($0) => \(self.request.params[$0])" })
  }
  
  func debugInfo() -> String {
    let env:Dictionary = NSProcessInfo().environment

    return "<h2>Environment</h2>" + "<br/>".join(env.keys.map{ "\($0) => \(env[$0])" })
  }
}
