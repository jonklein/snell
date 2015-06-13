//
//  TestRouter.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Cocoa

class TestRouter : Router {
  init(request: Request) {
    Router.route("/users", controller: TestController.self)

    Router.route("/xx") { (request:Request) -> Response in
      return Response(status: 200, body: "<h1>A message in a closure</h1>")
    }
  }
}