//
//  ActionResult.swift
//  Snell
//
//  Created by Matt Griffin on 6/25/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public enum Failable<T> {
  case Success(T)
  case Error(NSError)
  
  public init(error:NSError) {
    self = .Error(error)
  }
  
  public init(value:T) {
    self = .Success(value)
  }
  
  func success() -> T? {
    switch self {
      case .Success(let value):
        return value
      default:
        return nil
    }
  }
}
