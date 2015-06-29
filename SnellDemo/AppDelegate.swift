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
  var baseURLString:String?

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let snell = Snell(router: DemoRouter())
    let url = snell.startServer()

    self.baseURLString = url
    self.status.stringValue = "Running on \(url)"

    window.makeKeyAndOrderFront(self)
  }

  func applicationWillTerminate(aNotification: NSNotification) {
  }

  @IBAction func openURL(sender:AnyObject?) {
    if let url = self.baseURLString {
      NSWorkspace.sharedWorkspace().openURL(NSURL(string: url)!)
    }
  }
}

