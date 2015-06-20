//
//  Controller.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

public class Controller {
  public var request:Request

  public init(request:Request) {
    self.request = request
  }

  public func run() -> Response {
    return Response(status: 200, body: "Hello, world")
  }
}
