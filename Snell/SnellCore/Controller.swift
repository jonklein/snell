//
//  Controller.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation
import PromiseKit

public class Controller {
  public typealias Result = Failable<Response>

  public var request:Request

  required public init(request:Request) {
    self.request = request
  }

  public func render(type:View.Type, status:Int) -> AsyncResponse {
    return Promise { success, _ in success(Response(status: status, body: type().render(scope()))) }
  }

  public func scope() -> Scope {
    return Scope(request: request, environment: NSProcessInfo.processInfo().environment)
  }
}
