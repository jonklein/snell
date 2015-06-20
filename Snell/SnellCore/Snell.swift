//
//  Snell.swift
//  Snell
//
//  Created by Jonathan Klein on 6/20/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class Snell {
  var router:Router

  public init(router:Router) {
    self.router = router
  }

  public func startServer() {
    GCDWebServerAdapter(router: router, port: 3000).run()
  }

  public func startCGI() {
    let CGI = CGIAdapter()

    if let response = router.dispatch(CGI.request()!) {
      CGI.render(response)
    } else {
      CGI.render(Response(status: 500, body: "An internal error occured: action did not return a response"))
    }
  }
}