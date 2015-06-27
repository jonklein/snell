//
//  Cat.swift
//  Snell
//
//  Created by Jonathan Klein on 6/27/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class Cat : SnormModel {
  var name:String
  var color:String

  public init(name:String, color:String) {
    self.name = name
    self.color = color
  }
}