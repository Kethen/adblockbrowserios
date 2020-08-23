# adblockbrowserios
Adblock Browser for iOS
=======================

A web browser for iOS that includes content blocking, provided by AdBlock Plus

### asset.json is obtained from https://github.com/gorhill/uBlock/blob/master/assets/assets.json

### Requirements

Note: Adblock Browser requires [ABBCore](https://gitlab.com/eyeo/adblockplus/adblockbrowserios-core) to be cloned into the parent directory from Adblock Browser (this repository).
The directory structure should be configured as such:

```
- adblockbrowser
    |- adblockbrowserios (this repository)
    |- adblockbrowserios-core
```

- [Xcode 11.6](https://developer.apple.com/xcode/)
- [Carthage](https://github.com/Carthage/Carthage)
- [Sourcery](https://github.com/krzysztofzablocki/Sourcery)
- [SwiftLint](https://github.com/realm/SwiftLint/) (optional)

### Building in Xcode

1. Clone adblockbrowserios-core next to this project, follow all preparation instructions there in the project root
2. Run `carthage update` to install additional Swift dependencies.
3. Open _AdblockBrowser.xcworkspace_ in Xcode.
4. Build and run the project locally in Xcode.
