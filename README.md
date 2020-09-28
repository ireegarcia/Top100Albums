# Top100Albums
Top 100 albums, using Apple’s RSS generator

### Build and start

To build and run the project, you'll need a recent version of Xcode. The code was created for iOS 14, but is compatible with iOS 11 and up.

##### Compatibility issues

 To run the app on iOS before 12, a device is required (iOS 11 simulators might not be supported).

> The project was created using Xcode 12.0 with Swift 5.3. Older versions might present issues.

### Assumptions

- The architecture is _MVVM_, with a separate networking layer.
- The UI is written entirely in code, using Auto Layout.
- The tests are made using `XCTestCase`. There are 2 testing targets:
   - One for logic (and a bit of controller integration), which is faster since it doesn't need a host application.
   - One for UI testing (Unused. Deactivated in the run configuration).
