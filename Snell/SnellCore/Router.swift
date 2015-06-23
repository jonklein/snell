//
//  Router.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class Router {
  
  public var routingTable:[NSRegularExpression:(request:Request) -> Response] = [:]

  public init() {
  }

  public func route<T: Controller>(pattern:String, to action:(T) -> () -> Response) {
    route(pattern, closure: { request in action(T(request: request))() })
  }

  public func route(pattern:String, closure: (request:Request) -> Response) {
    do {
      let regex = try NSRegularExpression(pattern: "^\(pattern)$", options: NSRegularExpressionOptions())
      self.routingTable[regex] = closure
    } catch {
      NSLog("Error: could not compile pattern \(pattern)")
    }
  }

  func dispatch(request:Request) -> Response? {
    for pattern in routingTable.keys {
      let match = pattern.matchesInString(request.path as String, options: NSMatchingOptions(), range: NSMakeRange(0, request.path.characters.count))

      if match.count > 0 {
        if let response = self.routingTable[pattern]?(request: request) {
          return response
        } else {
          return Response(status: 500, body: "An internal error occured: action did not return a response")
        }
      }
    }

    return Response(status: 404, body: "No route matches this action")
  }
}
