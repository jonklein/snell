//
//  GCDWebServerAdapter.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/14/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Cocoa

public class GCDWebServerAdapter {
  let webServer = GCDWebServer()
  public var port = 3000
  public var router:Router

  public init(router:Router, port:Int = 3000) {
    self.port = port
    self.router = router
  }

  public func run() {
    setUpRequestHandlers()
    webServer.runWithPort(3000, bonjourName: "")
  }

  func setUpRequestHandlers() {
    for method in ["GET", "POST", "PUT", "DELETE", "PATCH"] {
      webServer.addDefaultHandlerForMethod(method, requestClass: GCDWebServerRequest.self, asyncProcessBlock: {
        gdcRequest, continuation in
        // Hack for swift compiler. Moves the reference into the same scope as the promise so that
        // the then block can capture it. No fucking clue.
        let cont = continuation
        
        self.handleRequest(gdcRequest)
          .then { dispatcherResponse in cont(self.response(dispatcherResponse))
        }
      })
    }
  }
  
  func handleRequest(GDCRequest:GCDWebServerRequest) -> AsyncResponse {
    let params = GDCRequest.query.keys.reduce([:], combine: { (var dict, key) -> [String:String] in
      dict[key as! String] = GDCRequest.query[key] as? String
      return dict
    })

    let request = Request(params: params, method: GDCRequest.method, path: GDCRequest.path)

    return router.dispatch(request)
  }

  func response(response:Response) -> GCDWebServerDataResponse {
    return GCDWebServerDataResponse(HTML:response.body)
  }
}



