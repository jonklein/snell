//
//  Repository.swift
//  Snell
//
//  Created by Matt on 6/27/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation
import PromiseKit

class Repository {
  class func find(id:Int) -> Promise<Repository> {
    return Promise{ success, _ in
      success(self())
    }
  }

  required init(){}
  
  func updateAttributes(attributes:[String:Any]) -> Promise<Bool> {
    return Promise { success, _ in
      success(true)
    }
  }
}