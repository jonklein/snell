
# Snell: a Proof-of-concept web framework written in Swift

Snell is a proof-of-concept web framework written in Swift 

Currently, a Swift Web framework has limited utility due to platform restrictions.  However, as Apple has [announced that Swift will be made open source](https://developer.apple.com/swift/), it is reasonable to expect that Swift will soon a viable option on more common web server platforms (namely Linux), or potentially any other platform supported by LLVM (such as Android [!]).

In the same sense that frameworks like Node.js offer the promise of a common web frontend & backend language, a Swift web framework could offer a common frontend/backend language for iOS/OSX apps, and again, eventually other platforms.

The design basis for Snell is largely Rails-inspired in some of the structure and terminology, though differences between Ruby & Swift do lead to different design considerations.  In particular, the relative lack of reflection & metaprogramming functionality in Swift presents a challenge in following many Rails design patterns.

*This project is only a proof-of-concept*.  It currently supports only the simplest of requests.  It goes without saying that it's not appopriate for production use.  See the section "Known Issues & Limitations" below for more details.

### Using Snell in a Project

*Snell requires Swift 2.0.*

To build a project with Snell, you can clone the demo project and modify files in the "SnellProject" group.  The files/directories of interest in the demo project are:

- `main.swift`: where the server is started and the router is configured
- `DemoRouter.swift`: routing between URL routes and server actions
- `DemoController.swift`: handling of server actions, trigger rendering, etc
- `Views`: templated Swift HTML views (see the section on `swtl` below)

In the future, Snell should be able to integrate into a project as an external framework or library, but there are currently some limitations in the Swift workflow that complicate this approach.  See "Known Issues & Limitations" below for more information.

### Running a Snell Project

There are currently two ways to run the framework: CGI, or standalone server.  The demo project is configured to run as a standalone server on port 3000.  If you run the `Snell` target in XCode via "Command-R", you should be able to reach the server in a browser at `http://localhost:3000`.  This will invoke the `main` action of `DemoController`, which will render the `Demo` template.

### `swtl` – templating with Swift

Part of the Snell project is `swtl` (pronounced "Swaddle"), a simple tool for is a simple tool for building templates using Swift.  In the context of Snell, this is most likely HTML templates, but the tool can be used for any kind of templating.  `swtl` allows for ERB-style Swift statements to be embedded in any kind of text content:

```
<html>
  <body>
    <p>Hello, <%= scope.request.params["name"] %></p>
    <% for i in 1...3 { %>
      <p>Iteration in a template (<%= i %>)
    <% } %>
  </body>
</html>
```

To use `swtl` in your project, you'll need to setup a custom build rule in Xcode to process the `.swtl` file into a `.swift` file.  See the demo project for an example.

### Known Issues & Limitations

- Most importantly -- Snell is just a proof of concept: *it is currently only built to handle simple GET requests*

The framework should be easily extensible to a more complete feature-set, but at this time, only simple GET requests returning HTML are supported.

- Not yet possible to build Swift CLI tools linked against a framework...

This limitation means that we cannot build a standalone command-line binary linking against a compiled Snell framework.

- ... nor is it possible to build static Swift libraries

Similar to the previous item, at this time it is does not appear possible to create static libraries in Swift, so the workflow does not allow one to easily build a statically linked Snell project without compiling against the Snell source directly.

- Lack of reflection support in Swift

Swift does have some very basic reflection support, but sadly seems to support far less in terms of metaprogramming than, for example, Objective C.  This introduces some design limitations on the framework, particularly with respect to things like request routing and configuration.  Many of the things handled more dynamically in frameworks such as Rails must be explicitly compiled into a Snell application.

Hopefully this situation improves as the Swift language evolves.

- Reliance on Apple libraries

Looking forward to an open-source Swift that runs on many platforms, Snell should avoid the use of any Apple-specific APIs including the Cocoa & Foundation frameworks.  For the time being, however, it is generally impractical to avoid all such dependencies.  Snell will migrate to non-Apple-specific APIs as they become readily available.

- `swtl` is a total hack

`swtl` simply turns mixes text/code templates into standalone Swift classes with a mass of print-statements.  This works in basic optmistic cases, but it likely to be fragile.  Furthermore, syntax errors or other compilation problems in template files are reported in the generated file, so filenames & line numbers can be difficult to track down.