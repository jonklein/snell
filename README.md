
# Snell: a Proof-of-concept web framework written in Swift

Snell is a proof-of-concept web framework written in Swift 

Currently, a Swift Web framework has limited utility due to platform restrictions.  However, as Apple has [announced that Swift will be made open source](https://developer.apple.com/swift/), it is reasonable to expect that Swift will soon a viable option on more common web server platforms (namely Linux), or potentially any other platform supported by LLVM (such as Android [!]).

In the same sense that frameworks like Node.js offer the promise of a common web frontend & backend language, a Swift web framework could offer a common frontend/backend language for iOS/OSX apps, and again, eventually other platforms.

*This project is only a proof-of-concept*.  It currently supports only the simplest of requests.  It goes without saying that it's not appopriate for production use.  See the section "Known Issues & Limitations" below for more details.

## Building a Project

To build a project with Snell, you can modify files in the "SnellProject" group.

### Running a Snell Project

There are currently two ways to run the framework: CGI, or standalone server.  Neither of these methods are considered high-performance options.

- Running with CGI

A Snell project can be compiled to run as a standlone CGI binary.

- Running as a standalone server

Snell uses the Cocoa GDCWebServer project to run as a simple standalone server.

## `swtl` – templating with Swift

Part of the Snell project 

`swtl` is a simple tool for building templates using Swift.  In the context of Snell, this is most likely HTML templates, but the tool can be used for any kind of templating.  `swtl` allows for ERB-style Swift statements to be embedded in any kind of text content:

```
<html>
  <body>
    <p>Hello, <%= scope.request.params["username"] %>
  </body>
</html>
```


## Known Issues & Limitations

- Snell is a proof of concept: *it is currently only built to handle simple GET requests*

The framework should be easily extensible to a more complete feature-set, but at this time, only simple GET returning HTML is 

- Not yet possible to build Swift CLI tools linked against a framework...

This limitation means that we cannot build a standalone command-line binary linking against a compiled Snell framework 

- ... nor is it possible to build static Swift libraries

Similar to the previous item, at this time it is does not appear possible to create static libraries in Swift, so the workflow does not allow one to easily build a statically linked Snell project without compiling against the Snell source directly.

- Lack of reflection support in Swift

Swift does have some very basic reflection support, but sadly seems to support far less in terms of metaprogramming than, for example, Objective C.  This introduces some design limitations on the framework, particularly with respect to things like request routing and configuration.  Many of the things handled more dynamically in frameworks such as Rails must be explicitly compiled into a Snell application.

Hopefully this situation improves as the Swift language evolves.

- Reliance on Apple libraries

Looking forward to an open-source Swift that runs on many platforms, Snell should avoid the use of any Apple-specific APIs including the Cocoa & Foundation frameworks.  For the time being, however, it is generally impractical to avoid all such dependencies.  Snell will migrate to non-Apple-specific APIs as they become readily available.

- `swtl` is a total hack

`swtl` simply turns mixes text/code templates into standalone Swift classes with a mass of print-statements.  This works in basic optmistic cases, but it likely to be fragile.  Furthermore, syntax errors or other compilation problems in template files are reported in the generated file, so line numbers 

