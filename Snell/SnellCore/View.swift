//
//  File.swift
//  Snell
//
//  Created by Jonathan Klein on 6/20/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class View {
  required public init() {
  }

  public func render(scope:Scope) -> String {
    return parse(scope)
  }

  public func parse(scope:Scope) -> String { return "" }
}