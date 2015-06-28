//
//  TemplateParser.swift
//  SwiftServer
//
//  Created by Jonathan Klein on 6/18/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Foundation

/**
 * SWTL parser class.  
 *
 * SWTL takes a template file, and translates it into a Swift View class file which produces the
 * contents of the template, including execution of embedded Swift expressions and control structures.
 */

class SwtlTemplate {
  func parse(file:String) -> String? {
    let basename = file.lastPathComponent.stringByDeletingPathExtension

    do {
      let fileContent = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding)
      return parse(fileContent, basename: basename)
    } catch let e {
      print(e)
      return nil
    }
  }

  func parse(text:NSString, basename:String) -> String? {
    var result = templateStart(basename)

    do {
      let regex = try NSRegularExpression(pattern: "<%(=?)(((?!%>).)*)%>", options: .DotMatchesLineSeparators)

      let matches:Array = regex.matchesInString(text as String, options: .ReportProgress, range: NSMakeRange(0, text.length))

      var start = 0
      for i:NSTextCheckingResult in matches {
        let prefix = text.substringWithRange(NSMakeRange(start, i.rangeAtIndex(0).location - start))
        let command = text.substringWithRange(i.rangeAtIndex(2))
        let shouldPrint = i.rangeAtIndex(1).length == 1

        result += "    append(" + " \"" + sanitize(prefix) + "\")\n"
        result += "    " + (shouldPrint ? "append(\(command))" : command) + "\n"

        start = i.rangeAtIndex(0).location + i.rangeAtIndex(0).length
      }

      let last = text.substringWithRange(NSMakeRange(start, text.length - start))
      result += "  append(" + " \"" + sanitize(last) + "\")\n"

      result += templateEnd()

      return result
    } catch let e {
      print(e)
      return nil
    }
  }

private
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

  func templateStart(name:String) -> String {
    return
      "#line 1 \"\(name).swtl\"\n" +
      "import Foundation\n\nimport SnellFramework\n\npublic class \(name) : View {\n" +
      "  var result = \"\"\n\n" +
      "  public func append(value: AnyObject) {\n" +
      "    self.result += \"\\(value)\"\n" +
      "  }\n\n" +
      "  public override func parse(scope:Scope) -> String {\n"
  }

  func templateEnd() -> String {
    return
      "    return self.result\n" +
      "  }\n}\n"
  }
}
