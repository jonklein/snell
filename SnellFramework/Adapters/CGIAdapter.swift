//
//  CGIAdapter.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//


// A simple adapter to produce a request from CGI environment input

import Cocoa

class CGIAdapter {
  func request() -> Request? {
    let env: Dictionary = NSProcessInfo().environment
    return Request(params: parseParams(env["QUERY_STRING"] ?? ""), method: env["REQUEST_METHOD"] ?? "GET", path: env["PATH_INFO"] ?? "")
  }

  func render(response:Response) {
    print("Content-Type: \(response.contentType)", terminator: "")
    print("Status: \(response.status)", terminator: "")
    print("Content:", terminator: "")
    print("", terminator: "")
    print(response.body, terminator: "")
  }

  func parseParams(query:String) -> [String:String] {
    return query.componentsSeparatedByString("&").reduce([String:String]()) { (var dict, str) -> [String:String] in
      let components:[String?] = str.componentsSeparatedByString("=").map{ return $0.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) }

      if(components.count == 2) {
        dict[components[0]!] = components[1]!
      }

      return dict
    }
  }
}
