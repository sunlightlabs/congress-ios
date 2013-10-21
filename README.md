# Congress for iOS

Follow the latest from Washington with the free Congress app from the nonpartisan Sunlight Foundation. Learn more about your members of Congress, including their contact information, and track activity on bills.

[![Congress for iOS on the App Store](http://cngr.es.s3.amazonaws.com/ios/appstore.png)](http://cngr.es/ios)

[More about Congress for Android and iOS](http://cngr.es)

[![Gittip](http://img.shields.io/gittip/congress_app.png)](https://www.gittip.com/congress_app/)

## Issues and Feedback

Please report all issues on our [GitHub issues page](https://github.com/sunlightlabs/congress-ios/issues).

## Development

Congress for iOS uses [TestFlight](https://testflightapp.com), [Crashlytics](http://crashlytics.com/), and [Sunlight API key](http://sunlightfoundation.com/api/). You'll need to register for these services.

1. Install [CocoaPods](http://cocoapods.org/) and `pod install`
1. `cp Other\ Sources/SFSettingsExample.h Other\ Sources/SFSettings.h`
1. `cp Other\ Sources/SFSettingsExample.m Other\ Sources/SFSettings.m`
1. Edit *Other Sources/SFSettings.m* to remove the *#error* line and set the appropriate constant values

That should be it. Build, run, and have at it.
