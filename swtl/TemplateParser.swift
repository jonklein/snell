//
//  TemplateParser.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/18/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

class Template {
  func parse(file:String) -> String? {
    var result = templateStart()

    do {
      let fileContent = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding)

      let regex = try NSRegularExpression(pattern: "<%(=?)(((?!%>).)*)%>", options: .DotMatchesLineSeparators)

      let matches:Array = regex.matchesInString(fileContent as String, options: .ReportProgress, range: NSMakeRange(0, fileContent.length))

      var start = 0
      for i:NSTextCheckingResult in matches {
        let prefix = fileContent.substringWithRange(NSMakeRange(start, i.rangeAtIndex(0).location - start))
        let command = fileContent.substringWithRange(i.rangeAtIndex(2))
        let shouldPrint = i.rangeAtIndex(1).length == 1

        result += "  print(" + " \"" + sanitize(prefix) + "\")\n"
        result += "  " + (shouldPrint ? "print(\(command))" : command) + "\n"

        start = i.rangeAtIndex(0).location + i.rangeAtIndex(0).length
      }

      let last = fileContent.substringWithRange(NSMakeRange(start, fileContent.length - start))
      result += "  print(" + " \"" + sanitize(last) + "\")\n"

      result += templateEnd()

      return result
    } catch let e {
      print(e)
      return nil
    }
  }

  func matches(content:NSString) throws -> [NSTextCheckingResult] {
    let parsingRegex = "<%(=?)(((?!%>).)*)%>"
    let regex = try NSRegularExpression(pattern: parsingRegex, options: .DotMatchesLineSeparators)
    return regex.matchesInString(content as String, options: .ReportProgress, range: NSMakeRange(0, content.length))
  }

  func sanitize(value:String) -> String {
    return value
      .stringByReplacingOccurrencesOfString("\t", withString: "\\t")
      .stringByReplacingOccurrencesOfString("\n", withString: "\\n")
      .stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
  }

private
  func templateStart() -> String {
    return "import Foundation\n\nfunc parse(scope:[String:AnyObject]) {\n"
  }

  func templateEnd() -> String {
    return
      "}\n" +
      "var scope:[String:AnyObject] = [:]\n" +
      "scope[\"arguments\"] = Process.arguments\n" +
      "parse(scope)\n"
  }
}
