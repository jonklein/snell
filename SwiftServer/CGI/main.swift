//
//  main.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/13/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation
import SwiftServerLib

let CGI = CGIAdapter()
CGI.render(TestController(request: CGI.request()!).run())
