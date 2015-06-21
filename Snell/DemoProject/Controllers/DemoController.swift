//
//  DemoController.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

class DemoController: Controller {
  // Internal controller subclasses allow for shared controller functionality in a single class/file.

  class Main : DemoController {
    internal override func run() -> Response {
      return render(Demo.self, status: 200)
    }
  }
}
