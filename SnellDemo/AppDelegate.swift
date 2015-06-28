//
//  AppDelegate.swift
//  SnellDemo
//
//  Created by Jonathan Klein on 6/28/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Cocoa
import SnellFramework

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var status: NSTextField!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let snell = Snell(router: DemoRouter())
    let url = snell.startServer()

    self.status.stringValue = "Running on \(url)"

    window.makeKeyAndOrderFront(self)
  }

  func run() {
  }

  func applicationWillTerminate(aNotification: NSNotification) {
  }
}

