//
//  Snorm.swift
//  Snell
//
//  Created by Jonathan Klein on 6/27/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

public class SnormModel : NSObject {
  public var id:String? = nil

  override public var description: String { return "\(self.dynamicType.snormTableName()) - \(self.id)" }

  class func snormTableName() -> String { return NSStringFromClass(self) }

  public class func with(expression:String, _ arg: CVarArgType...) -> SnormScope<SnormModel> {
    return SnormScope(cls: self, expression: expression, arguments: getVaList(arg))
  }

  public class func all() -> SnormScope<SnormModel> {
    return with("TRUEPREDICATE")
  }

  public class func first() -> SnormModel? {
    return all().first
  }


  public init(coder:NSCoder!) {
    super.init()
    if let dict = coder.decodeObject() as? [String:AnyObject] {
      fromDictionary(dict)
    }
  }

  public override init() {}

  public func save() -> SnormModel {
    SnormAdapter.sharedAdapter().insert([self])
    return self
  }

  public func destroy() -> SnormModel {
    SnormAdapter.sharedAdapter().destroy([self])
    return self
  }

  public func saved() -> Bool {
    return self.id != nil
  }

  func toDictionary() -> NSDictionary {
    let propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
    var cls:AnyClass! = self.dynamicType

    while(cls != NSObject.self) {
      var propertiesCount : CUnsignedInt = 0
      let propertiesInAClass : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(cls, &propertiesCount)
      for var i = 0; i < Int(propertiesCount); i++ {
        let property = propertiesInAClass[i]
        let propName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding) as! String
        let propValue : AnyObject! = self.valueForKey(propName)

        if let modelValue = propValue as? SnormModel {
          propertiesDictionary.setValue(modelValue.toDictionary(), forKey: propName)
        } else if let arrayValue = propValue as? [AnyObject] {
          propertiesDictionary.setValue(arrayValue.map { $0.toDictionary() }, forKey: propName)
        } else {
          propertiesDictionary.setValue(propValue, forKey: propName)
        }
      }

      cls = class_getSuperclass(cls)
    }
    return propertiesDictionary
  }

  func fromDictionary(dict:[String:AnyObject]) {
    for key in dict.keys {
      self.setValue(dict[key], forKey: key)
    }
  }

  public override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    NSLog("Warning: attempt to set unsupported key \(key)")
  }

  func encodeWithCoder(coder:NSCoder) {
    coder.encodeObject(toDictionary())
  }
}
