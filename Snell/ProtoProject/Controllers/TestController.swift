//
//  TestController.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

class TestController: Controller {
  internal override func run() -> Response {
    return render(Hello.self, status: 200)
  }
}
