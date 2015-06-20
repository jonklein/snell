//
//  Request.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class Request {
  public var params:[String: String]
  public var method:String
  public var path:String

  public init(params:[String: String], method:String, path:String) {
    self.method = method
    self.params = params
    self.path = path
  }
}
