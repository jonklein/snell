//
//  Snorm.swift
//  Snell
//
//  Created by Jonathan Klein on 6/27/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class SnormScope<T> {
  var expression:NSPredicate

  public lazy var objects:[T] = self.execute()
  public lazy var array:[T]   = self.objects // more swifty?
  public var first:T? { return self.objects.first }

  public init<T>(cls:T, expression:String, parent:SnormScope? = nil, arguments: CVaListPointer? = nil) {
    self.expression = arguments != nil ?
      NSPredicate(format: expression, arguments: arguments!) :
      NSPredicate(format: expression)

    if let p = parent {
      self.expression = NSCompoundPredicate(andPredicateWithSubpredicates: [self.expression, p.expression])
    }
  }

  public func with(expression:String, arg: CVarArgType...) -> SnormScope<T> {
    return SnormScope(cls: T.self, expression: expression, parent: self, arguments: getVaList(arg))
  }

  public func execute() -> [T] {
    return SnormAdapter.sharedAdapter().fetch(self)
  }
}
