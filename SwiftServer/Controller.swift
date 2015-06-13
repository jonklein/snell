//
//  Controller.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

class Controller {
  var request:Request

  init(request:Request) {
    self.request = request
  }

  func run() -> Response {
    return Response(status: 200, body: "Hello, world")
  }
}
