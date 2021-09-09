# LogStore

A tiny package to make log output accessible from within an iOS app.

Based on Appendix 1. Debugging on the Go, of Build Location-Based Projects for iOS, by Dominik Hauser.

Some parts were filled in or improved by inspection of the LogStore repo at https://github.com/dasdom/LogStore

### Usage: 
printLog is a globally available function to print to the debug console & add an entry to the stored log.

```swift
import LogStore

printLog("something to log")
```

The log is stored in the users home directory of the iOS file system.

To view the log within your application there is a recommendations in Debugging on the Go, Appendix 1.
When the log is viewed there are buttons for Clear Log and Email Log.

The log can be emailed as an attachment named LogStore log.json.  The name of the app that is using the LogStore package can be included in the email.  Set the app name as:

```swift
import LogStore

setLoggingAppName("MyAppName")
```

