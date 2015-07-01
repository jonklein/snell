//
//  Controller.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class Controller {
  public typealias Result = Failable<Response>
  
  public var request:Request

  required public init(request:Request) {
    self.request = request
  }

  public func render(type:View.Type, status:Int, locals:[String:AnyObject] = [:]) -> Result {
    return Result(value: Response(status: status, body: type.init().render(scope(locals))))
  }

  public func scope(locals:[String:AnyObject] = [:]) -> Scope {
    return Scope(request: request, environment: NSProcessInfo.processInfo().environment, locals: locals)
  }
}
