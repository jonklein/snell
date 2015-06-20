//
//  TestRouter.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Cocoa
import SwiftServerLib

class TestRouter : Router {
  init(request: Request) {
    Router.route(".*closure.*") { (request:Request) -> Response in
      return Response(status: 200, body: "<h1>A message in a closure</h1>")
    }

    Router.route("/cats/.*", controller: TestController.self)

    Router.route(".*", controller: TestController.self)

    super.init()
  }
}