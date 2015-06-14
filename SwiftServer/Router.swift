//
//  Router.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

class Router {
  class func route(pattern:String, controller:Controller.Type) {}
  class func route(pattern:String, closure: (request:Request) -> (Response)) {}

  func dispatch(request:Request) {

  }
}
