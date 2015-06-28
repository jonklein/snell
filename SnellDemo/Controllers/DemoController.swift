//
//  DemoController.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation
import SnellFramework

class DemoController: Controller {
  
  func index() -> Result {
    return render(Demo.self, status: 200)
  }
  
  func create() -> Result {
    return Result(error: NSError(domain:"test", code:2, userInfo:nil))
  }
}
