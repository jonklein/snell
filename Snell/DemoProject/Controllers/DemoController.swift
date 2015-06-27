//
//  DemoController.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation
import PromiseKit

class DemoController: Controller {
  
  class User : Repository {
    required init() {}
  }
  
  func index() -> Promise<Response> {
    return render(Demo.self, status: 200)
  }
  
//  def update
//    user = User.find(1)
//    if user.update_attributes(params[:user])
//      respond_with(@user)
//    else
//      respond_with(@user.errors, :status => :unprocessable_entity)
//    end
//  end
  
  func update() -> Promise<Response> {
    // Swift's current level of suck at type inference and closures makes this more verbose than
    // would otherwise be expected. It should be solvable in llvm and hopefully the situation improves.
    return User.find(1)
      .then({ (user:Repository) -> Promise<Response> in
        let user = user as! User
        return user.updateAttributes(["name": "Test"])
          .then({ (valid:Bool) -> Response in
            if valid {
              return Response(status: 200, body: "User updated")
            } else {
              return Response(status: 422, body: "Validation errors")
            }
          })
      })
  }
}
