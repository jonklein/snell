//
//  Controller.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class Controller {
  public var request:Request

  required public init(request:Request) {
    self.request = request
  }

  public func run() -> Response {
    return Response(status: 200, body: "Hello, world")
  }

  public func render(type:View.Type, status:Int) -> Response {
    return Response(status: status, body: type().render(scope()))
  }

  public func scope() -> Scope {
    return Scope(request: request, environment: NSProcessInfo.processInfo().environment)
  }
}
