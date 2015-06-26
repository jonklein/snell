//
//  SwiftServerTests.swift
//  SwiftServerTests
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Quick
import Nimble

class CGIAdapterSpec: QuickSpec {
  override func spec() {
    describe("CGI Requests") {
      beforeEach {
        setenv("REQUEST_METHOD", "POST", 1)
        setenv("QUERY_STRING", "x=1&y=2", 1)
      }

      it("should set request method") {
        expect(CGIAdapter().request()!.method).to(equal("POST"))
      }

      it("should set parameters") {
        expect(CGIAdapter().request()!.params["x"]!).to(equal("1"))
      }

      it("should decode percent encoded characters") {
        setenv("QUERY_STRING", "x=1&y=2%25%26", 1)
        expect(CGIAdapter().request()!.params["y"]!).to(equal("2%&"))
      }
    }
  }
}