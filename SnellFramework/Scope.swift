//
//  Scope.swift
//  Snell
//
//  Created by Jonathan Klein on 6/20/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class Scope {
  public var environment:[String:String]
  public var request:Request
  public var locals:[String:AnyObject]

  public init(request:Request, environment:[String:String], locals:[String:AnyObject] = [:]) {
    self.environment = environment
    self.request = request
    self.locals = locals
  }

  public func set(key:String, value: String) {
    self.locals[key] = value
  }
}