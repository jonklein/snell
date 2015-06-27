//
//  DemoRouter.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation
import SnellFramework

class DemoRouter : Router {
  // The Router init is the main override point for your Snell app.

  override init() {
    super.init()

    // Route the homepage to the "DemoController.index" action
    route("/", to: DemoController.index)

    // Route showing how to do a post 
    route("/", via:HTTPMethod.Post, to: DemoController.create)
    
    // Route "/closure" to a demo of defining an action as a closure, rather than a controller
    route("/closure") { request in
      Controller.Result(value: Response(status: 200, body: "<h1>An action in a closure...</h1>"))
    }

    // Route
    route("/cats", to: CatsController.index)
    route("/cats", via: HTTPMethod.Post, to: CatsController.create)
    route("/cats/new", to: CatsController.new)
  }
}