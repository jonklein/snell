//
//  Response.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

public class Response {
  var status:Int
  var body:String
  var contentType:String = "text/html"

  public init(status:Int, body:String) {
    self.body = body
    self.status = status
  }
}
