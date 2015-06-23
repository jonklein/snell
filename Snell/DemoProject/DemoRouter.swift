//
//  DemoRouter.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Cocoa

class DemoRouter : Router {
  // The Router init is the main override point for your Snell app.

  override init() {
    super.init()

    // Route the homepage to the "DemoController.index" action

    route("/", to: DemoController.index)

    // Route "/closure" to a demo of defining an action as a closure, rather than a controller

    route("/closure") { (request:Request) -> Response in
      return Response(status: 200, body: "<h1>An action in a closure...</h1>")
    }
  }
}