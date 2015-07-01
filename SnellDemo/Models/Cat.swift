//
//  Cat.swift
//  Snell
//
//  Created by Jonathan Klein on 6/27/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation
import SnellFramework

public class Cat : SnormModel {
  var name:String?
  var color:String?

  init(name:String, color:String) {
    self.name = name
    self.color = color
    super.init()
  }

  override init(coder aCoder:NSCoder!) {
    super.init(coder: aCoder)
  }
}