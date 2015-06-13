//
//  Request.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

class Request {
  var params:[String: String]
  var method:String
  var path:String

  init(params:[String: String], method:String, path:String) {
    self.method = method
    self.params = params
    self.path = path
  }
}
