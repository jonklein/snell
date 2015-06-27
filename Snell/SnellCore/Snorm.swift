//
//  Snorm.swift
//  Snell
//
//  Created by Jonathan Klein on 6/27/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation


// Base class for any database backend.  There's currently only a single SnormMemoryAdapter() class involved
public class SnormAdapter {
  // hardcoded as SnormMemoryAdapter -- should be some initialization/configuration here
  static var adapter:SnormAdapter? = SnormMemoryAdapter()

  public class func sharedAdapter() -> SnormAdapter {
    return self.adapter!
  }

  public func reset() {}

  public func fetch<T>(filter:SnormScope<T>) -> [T] { return [] }
  public func insert<T>(objects:[T]) {}
  public func update<T>(objects:[T]) {}
  public func destroy<T>(objects:[T]) {}
}


/** 
 * An in-memory backend.  Mostly for development.  And until there's something else.
 */

public class SnormMemoryAdapter : SnormAdapter {
  var store:[String:[String:SnormModel]] = [String:[String:SnormModel]]()

  public override func reset() { store = [String:[String:SnormModel]]() }

  public override func fetch<T: SnormModel>(filter:SnormScope<T>) -> [T] {
    let objectTable = objects(T)
    return NSArray(array: objectTable.values.array).filteredArrayUsingPredicate(filter.expression) as! [T]
  }

  public override func insert<T: SnormModel>(insertionObjects:[T]) {
    var objectTable = objects(T)

    for o in insertionObjects {
      o.id = NSUUID().UUIDString
      objectTable[o.id!] = o
    }

    store[T.snormTableName()] = objectTable
  }

  public override func update<T: SnormModel>(updateObjects:[T]) {
    var objectTable = objects(T)

    for o in updateObjects {
      if let id = o.id {
        objectTable[id] = o
      }
    }

    store[T.snormTableName()] = objectTable
  }

  public override func destroy<T: SnormModel>(deletionObjects: [T]) {
    var objectTable = objects(T)

    for o in deletionObjects {
      if let id = o.id {
        objectTable.removeValueForKey(id)
      }
    }

    store[T.snormTableName()] = objectTable
  }

  func objects<T: SnormModel>(type:T.Type) -> [String:T] {
    var objectTable = store[T.snormTableName()] as? [String:T]

    if objectTable == nil {
      objectTable = [String:T]()
      store[T.snormTableName()] = objectTable
    }

    return objectTable!
  }
}



public class SnormScope<T> {
  var expression:NSPredicate

  lazy var objects:[T] = self.execute()
  lazy var array:[T]   = self.objects // more swifty?

  public init<T>(cls:T, expression:String, parent:SnormScope? = nil) {
    self.expression = NSPredicate(format: expression)

    if let p = parent {
      self.expression = NSCompoundPredicate.andPredicateWithSubpredicates([self.expression, p.expression])
    }
  }

  func with(expression:String) -> SnormScope<T> {
    return SnormScope(cls: T.self, expression: expression, parent: self)
  }

  func execute() -> [T] {
    return SnormAdapter.sharedAdapter().fetch(self)
  }
}



public class SnormModel : NSObject {
  public var id:String? = nil

  override public var description: String { return "\(self.dynamicType.snormTableName()) - \(self.id)" }

  class func snormTableName() -> String { return NSStringFromClass(self) }

  class func all() -> SnormScope<SnormModel> {
    return SnormScope(cls: self, expression: "TRUEPREDICATE")
  }

  class func with(expression:String) -> SnormScope<SnormModel> {
    return SnormScope(cls: self, expression: expression)
  }

  func save() -> SnormModel {
    SnormAdapter.sharedAdapter().insert([self])
    return self
  }

  func destroy() -> SnormModel {
    SnormAdapter.sharedAdapter().destroy([self])
    return self
  }

  func saved() -> Bool {
    return self.id != nil
  }
}
