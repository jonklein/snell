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
    router.dispatch(CGI.request()!)
      .then { response in CGI.render(response) }
  }
}