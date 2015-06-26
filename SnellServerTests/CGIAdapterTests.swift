//
//  SwiftServerTests.swift
//  SwiftServerTests
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//


import Quick
import Nimble
import AppKit

class CGIAdapterSpec: QuickSpec {
  override func spec() {
    describe("CGI Requests") {
      it("should set request method") {
        setenv("REQUEST_METHOD", "POST", 1)
        setenv("QUERY_STRING", "x=1&y=2", 1)
        expect(CGIAdapter().request()!.method).to(equal("POST"))
      }

      it("should set parameters") {
        setenv("REQUEST_METHOD", "POST", 1)
        setenv("QUERY_STRING", "x=1&y=2", 1)
        expect(CGIAdapter().request()!.params["x"]!).to(equal("1"))

      }

      it("should decode percent encoded characters") {
        setenv("REQUEST_METHOD", "POST", 1)
        setenv("QUERY_STRING", "x=1&y=2%25%26", 1)
        expect(CGIAdapter().request()!.params["y"]!).to(equal("2%&"))
      }
    }
  }
}