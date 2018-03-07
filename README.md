# Concurrency Starter for Swift 4

This Xcode 9 project demonstrates concurrency in iOS using Grand Central Dispatch (GCD) and compares concurrent (asynchronous) queues and serial (synchronous) queues.

The Swift language migration wizard was used to convert this project to Swift 4. (In Xcode, see the "Edit" menu -> "Convert" -> "To Current Swift Syntax..."). The original project was created in Xcode 8.2.1 with Swift 3.

Here's this app in action:

![alt text][logo1]

[logo1]: http://iosbrain.com/blog/wp-content/uploads/2018/03/ConcurrentApp_small.png "GCD concurrency app"

## Xcode 9 project settings
**To get this project running on the Simulator or a physical device (iPhone, iPad)**, go to the following locations in Xcode and make the suggested changes:

1. Project Navigator -> [Project Name] -> Targets List -> TARGETS -> [Target Name] -> General -> Signing
- [ ] Tick the "Automatically manage signing" box
- [ ] Select a valid name from the "Team" dropdown
  
2. Project Navigator -> [Project Name] -> Targets List -> TARGETS -> [Target Name] -> General -> Identity
- [ ] Change the "com.yourDomainNameHere" portion of the value in the "Bundle Identifier" text field to your real reverse domain name (i.e., "com.yourRealDomainName.Project-Name").
