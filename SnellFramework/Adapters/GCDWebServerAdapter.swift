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

    for method in ["GET", "POST", "PUT", "DELETE", "PATCH"] {
      webServer.addDefaultHandlerForMethod(method, requestClass: GCDWebServerURLEncodedFormRequest.self, processBlock: { gdcRequest in
        return self.response(self.handleRequest(gdcRequest))
      })
    }
  }

  public func run() -> String {
    webServer.startWithPort(3000, bonjourName: "")
    return webServer.serverURL.absoluteString
  }

  public func handleRequest(GDCRequest:GCDWebServerRequest) -> Response {
    var params = GDCRequest.query.keys.reduce([:], combine: { (var dict, key) -> [String:String] in
      dict[key as! String] = GDCRequest.query[key] as? String
      return dict
    })

    if let postParams = (GDCRequest as? GCDWebServerURLEncodedFormRequest)?.arguments {
      params = postParams.keys.reduce(params, combine: { (var dict, key) -> [String:String] in
        dict[key as! String] = postParams[key] as? String
        return dict
      })
    }

    let request = Request(params: params, method: GDCRequest.method, path: GDCRequest.path)

    return router.dispatch(request)
  }

  public func response(response:Response) -> GCDWebServerDataResponse {
    return GCDWebServerDataResponse(HTML:response.body)
  }
}



