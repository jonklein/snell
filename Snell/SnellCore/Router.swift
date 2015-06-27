//
//  Router.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation
import PromiseKit

public class Router {
  
  typealias Handler = (Request) -> () -> AsyncResponse
  
  public enum HTTPMethod : String {
    case Get     = "GET"
    case Post    = "POST"
    case Put     = "PUT"
    case Delete  = "DELETE"
    case Patch   = "PATCH"
  }
  
  class Route {
    var method:HTTPMethod
    var pattern:NSRegularExpression
    var handler:Handler
    
    init(method:HTTPMethod, pattern:NSRegularExpression, handler:Handler) {
      self.method = method
      self.pattern = pattern
      self.handler = handler
    }
    
    func matches(request:Request) -> Bool {
      if (method.rawValue == request.method) {
        let match = pattern.matchesInString(request.path as String, options: NSMatchingOptions(), range: NSMakeRange(0, request.path.characters.count))
        return match.count > 0
      }
      return false
    }
  }
  
  var routingTable:[Route] = []

  public init() {
  }
  
  public func route<T: Controller>(pattern:String, via:HTTPMethod = HTTPMethod.Get, to action:(T) -> () -> AsyncResponse) {
    route(pattern, via:via, closure: { request in action(T(request: request))() })
  }

  public func route(pattern:String, via:HTTPMethod = HTTPMethod.Get, closure: (request:Request) -> AsyncResponse) {
    do {
      let regex = try NSRegularExpression(pattern: "^\(pattern)$", options: NSRegularExpressionOptions())
      self.routingTable.append(Route(method: via, pattern: regex, handler: { (r:Request) -> () -> AsyncResponse in { closure(request: r) } }))
    } catch {
      NSLog("Error: could not compile pattern \(pattern)")
    }
  }

  func dispatch(request:Request) -> AsyncResponse {
    let route = routingTable.filter({ route in route.matches(request) }).first
    let response:AsyncResponse = {
      switch route {
      case .Some(let route):
        return route.handler(request)()
          .recover { _ in Response(status: 500, body: "An error occurred") }
      default:
        return async(Response(status: 404, body: "No route matches this action"))
      }
    }()
    
    return response.then { (response) -> Response in
      NSLog("\(request.method) \(request.path) \(response.status)")
      return response
    }
  }
  
  func async(response:Response) -> AsyncResponse {
    return Promise { success, _ in success(response) }
  }
}
