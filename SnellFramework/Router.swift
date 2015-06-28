//
//  Router.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class Router {
  
  typealias Handler = (Request) -> () -> Controller.Result
  
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
    var interpolations:[String]

    init(method:HTTPMethod, pattern:NSRegularExpression, handler:Handler, interpolations:[String] = []) {
      self.method = method
      self.pattern = pattern
      self.handler = handler
      self.interpolations = interpolations
    }
    
    func matches(request:Request) -> Bool {
      if (method.rawValue == request.method) {
        let match = pattern.matchesInString(request.path as String, options: NSMatchingOptions(), range: NSMakeRange(0, request.path.characters.count))
        return match.count > 0
      }
      return false
    }

    func interpolations(request:Request) -> [String:String] {
      let matches = pattern.matchesInString(request.path as String, options: NSMatchingOptions(), range: NSMakeRange(0, request.path.characters.count))

      return self.interpolations.enumerate().reduce([String:String]()) { (var memo:[String:String], t:(Int, String)) -> [String:String] in
        let (index, name) = t
        memo[name] = NSString(string: request.path).substringWithRange(matches[index].rangeAtIndex(1))
        return memo
      }
    }
  }
  
  var routingTable:[Route] = []

  public init() {
  }
  
  public func route<T: Controller>(pattern:String, via:HTTPMethod = HTTPMethod.Get, to action:(T) -> () -> Controller.Result) {
    route(pattern, via:via, closure: { request in action(T(request: request))() })
  }

  public func route(pattern:String, via:HTTPMethod = HTTPMethod.Get, closure: (request:Request) -> Controller.Result) {
    do {
      let (pattern, interpolations) = patternByReplacingInterpolations(pattern)

      let regex = try NSRegularExpression(pattern: "^\(pattern)$", options: NSRegularExpressionOptions())
      self.routingTable.append(Route(method: via, pattern: regex, handler: { (r:Request) -> () -> Controller.Result in { closure(request: r) } }, interpolations: interpolations))
    } catch {
      NSLog("Error: could not compile pattern \(pattern)")
    }
  }

  func dispatch(request:Request) -> Response {
    var response:Response
    if let route = routingTable.filter({ route in route.matches(request) }).first {

      route.interpolations(request).map { s -> String in
        let (k, v) = s
        request.params[k] = v
        return ""
      }

      let result = route.handler(request)()
      if let r = result.success() {
        response = r
      } else {
        response = Response(status: 500, body: "An error occurred")
      }
    } else {
      response = Response(status: 404, body: "No route matches this action")
    }
    
    NSLog("\(request.method) \(request.path) \(response.status)")
    return response
  }

  func patternByReplacingInterpolations(pattern:String) -> (String, [String]) {
    do {
      let range = NSMakeRange(0, pattern.characters.count)
      let regex = try NSRegularExpression(pattern: ":([a-zA-Z0-9_]+)", options: NSRegularExpressionOptions())
      let matches = regex.matchesInString(pattern, options: NSMatchingOptions(), range: range).map { match -> String in
        return NSString(string: pattern).substringWithRange(match.rangeAtIndex(1))
      }

      print("Found matches: \(matches)")

      return (regex.stringByReplacingMatchesInString(pattern, options: NSMatchingOptions(), range: range, withTemplate: "(.*)"), matches)
    } catch {
      return (pattern, [])
    }
  }
}
