//
//  SwtlParserTests.swift
//  Snell
//
//  Created by Jonathan Klein on 6/20/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Quick
import Nimble

class SwtlParserSpec: QuickSpec {
  override func spec() {
    describe("swtl template functionality") {
      // Really rough code level template tests

      var result:String!

      beforeEach {
        result = Template().parse("testing <%= 3 + 4 % %>", basename: "SwtlSpec")!
      }

      it("should generate a class with the specified classname") {
        expect(result).to(match("public\\W*class\\W*SwtlSpec"))
      }

      it("should generate a class with a parse method") {
        expect(result).to(match("func\\W*parse"))
      }

      it("should include literal code") {
        expect(result).to(match(".*3\\W*+\\W*4.*"))
      }
    }

    describe("swtl test templates") {
      // Run some test templates, all expected to produce the same output in different ways

      var scope:Scope!

      beforeEach {
        scope = Scope(request: Request(params: ["value": "2"], method: "GET", path: "/"), environment: [:])
      }

      it("should produce correct output for text") {
        expect(TestText().parse(scope)).to(equal("123"))
      }

      it("should produce correct output for swift expressions") {
        expect(TestExpression().parse(scope)).to(equal("123"))
      }

      it("should produce correct output for swift control structures") {
        expect(TestControl().parse(scope)).to(equal("123"))
      }

      it("should produce correct output for swift control structures") {
        expect(TestScope().parse(scope)).to(equal("123"))
      }
    }
  }
}
