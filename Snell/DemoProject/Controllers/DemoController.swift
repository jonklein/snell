//
//  DemoController.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

class DemoController: Controller {
  
  func index() -> Response {
    return render(Demo.self, status: 200)
  }
  
}
