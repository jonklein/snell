//
//  SwiftServerTests.swift
//  SwiftServerTests
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import XCTest

class CGIAdapterTests: XCTestCase {
  override func setUp() {
    setenv("REQUEST_METHOD", "POST", 1)
    setenv("QUERY_STRING", "x=1&y=2", 1)
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testShouldSetRequestMethod() {
    XCTAssertEqual(CGIAdapter().request()!.method, "POST")
  }

  func testShouldSetParameters() {
    XCTAssertEqual(CGIAdapter().request()!.params["x"]!, "1")
    XCTAssertEqual(CGIAdapter().request()!.params["y"]!, "2")
  }

  func testShouldDecodePercentEncodedChars() {
    setenv("QUERY_STRING", "x=1&y=2%25%26", 1)
    XCTAssertEqual(CGIAdapter().request()!.params["x"]!, "1")
    XCTAssertEqual(CGIAdapter().request()!.params["y"]!, "2%&")
  }

}
