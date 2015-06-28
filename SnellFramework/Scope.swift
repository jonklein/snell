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
  public var values:[String:AnyObject] = [:]

  public init(request:Request, environment:[String:String]) {
    self.environment = environment
    self.request = request
  }

  public func set(key:String, value: String) {
    self.values[key] = value
  }
}