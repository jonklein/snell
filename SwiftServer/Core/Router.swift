//
//  Router.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

public class Router {
  public class func route(pattern:String, controller:Controller.Type) {}
  public class func route(pattern:String, closure: (request:Request) -> (Response)) {}

  public init() {
  }
  
  func dispatch(request:Request) {

  }
}
