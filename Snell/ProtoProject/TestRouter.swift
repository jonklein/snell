//
//  TestRouter.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Cocoa

class TestRouter : Router {
  override init() {
    super.init()

    route("/", controller: TestController.self)

    route("/closure") { (request:Request) -> Response in
      return Response(status: 200, body: "<h1>An action in a closure...</h1>")
    }
  }
}