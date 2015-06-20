//
//  GCDWebServerAdapter.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/14/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Cocoa

public class GCDWebServerAdapter {
  public var request:Request

  public init(GDCRequest:GCDWebServerRequest) {
    let params = GDCRequest.query.keys.reduce([:], combine: { (var dict, key) -> [String:String] in
      dict[key as! String] = GDCRequest.query[key] as? String
      return dict
    })

    self.request = Request(params: params, method: GDCRequest.method, path: GDCRequest.path)
  }

  public func response(response:Response) -> GCDWebServerDataResponse {
    return GCDWebServerDataResponse(HTML:response.body)
  }
}
