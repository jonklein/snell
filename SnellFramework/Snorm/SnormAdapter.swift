//
//  Snorm.swift
//  Snell
//
//  Created by Jonathan Klein on 6/27/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation


// Base class for any database backend.  There's currently only a single SnormPlistAdapter() class written

public class SnormAdapter {
  // hardcoded as SnormPlistAdapter -- should be some initialization/configuration here
  static var adapter:SnormAdapter? = SnormPlistAdapter()

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
 * A simple plist backend.  Mostly for development.  And until there's something else.
 */
public class SnormPlistAdapter : SnormAdapter {
  var store:[String:[String:SnormModel]] = [String:[String:SnormModel]]()
  var storeName = "DefaultStore"

  public override func reset() {
    store = [String:[String:SnormModel]]()
    commit()
  }

  func storePath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
    return "\(paths[0])/Snell/\(storeName).plist"
  }

  public override init() {
    super.init()
    
    do {
      try NSFileManager.defaultManager().createDirectoryAtPath(NSString(string: storePath()).stringByDeletingLastPathComponent, withIntermediateDirectories: true, attributes: nil)
    } catch {}

    self.store = ((NSKeyedUnarchiver.unarchiveObjectWithFile(storePath()) ?? [String:[String:SnormModel]]())) as! [String : [String : SnormModel]]
  }


  func commit() {
    NSKeyedArchiver.archiveRootObject(NSDictionary(dictionary: store), toFile: storePath())
  }

  public override func fetch<T: SnormModel>(filter:SnormScope<T>) -> [T] {
    let objectTable = objects(T)
    return NSArray(array: Array(objectTable.values)).filteredArrayUsingPredicate(filter.expression) as! [T]
  }

  public override func insert<T: SnormModel>(insertionObjects:[T]) {
    var objectTable = objects(T)

    for o in insertionObjects {
      o.id = NSUUID().UUIDString
      objectTable[o.id!] = o
    }

    store[T.snormTableName()] = objectTable
    commit()
  }

  public override func update<T: SnormModel>(updateObjects:[T]) {
    var objectTable = objects(T)

    for o in updateObjects {
      if let id = o.id {
        objectTable[id] = o
      }
    }

    store[T.snormTableName()] = objectTable
    commit()
  }

  public override func destroy<T: SnormModel>(deletionObjects: [T]) {
    var objectTable = objects(T)

    for o in deletionObjects {
      if let id = o.id {
        objectTable.removeValueForKey(id)
      }
    }

    store[T.snormTableName()] = objectTable
    commit()
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

