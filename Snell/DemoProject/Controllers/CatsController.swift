//
//  DemoController.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

class CatsController: Controller {
  func index() -> Result {
    return render(CatsIndex.self, status: 200, locals: ["cats": Cat.all().array])
  }
  
  func create() -> Result {
    if let name = self.request.params["name"], color = self.request.params["color"] {
      let cat = Cat(name: name, color: color).save()
      return render(CatsCreate.self, status: 201, locals: ["cat": cat])
    } else {
      return render(CatsNew.self, status: 422, locals: ["flash": "Missing cat info!"])
    }
  }

  func new() -> Result {
    return render(CatsNew.self, status: 200)
  }

  func destroy() -> Result {
    if let id = self.request.params["id"], cat = Cat.with("id = %@", id).first {
      cat.destroy()
      return index()
    } else {
      return render(CatsIndex.self, status: 404, locals: ["cats": Cat.all().array, "flash": "Cat not found!"])
    }
  }
}
