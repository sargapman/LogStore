# LogStore

A tiny package to make log output accessible from within an iOS app.

Based on Chapter 1. Debugging on the Go, of Build Location-Based Projects for iOS, by Dominik Hauser.

Some parts were filled in or improved by inspection of the LogStore repo at https://github.com/dasdom/LogStore

### Usage: 
printLog is a globally available function to print to the debug console & add an entry to the stored log.

```swift
import LogStore

printLog("something to log")
```
To view the log within your application there are a couple recommendations in the LogStore repo.  There is an implementation of one of those in the LogStoreDevelopment app.

The log is stored in the users home directory of the iOS file system .  Currently there is no way to clear the log file other than deleting or replacing the app.

