UITextView+Placeholder
======================

[![CI](https://github.com/devxoul/UITextView-Placeholder/actions/workflows/ci.yml/badge.svg)](https://github.com/devxoul/UITextView-Placeholder/actions/workflows/ci.yml)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

A missing placeholder for UITextView.

> **Note**: CocoaPods support has been removed. Please use Swift Package Manager for installation.

Fork maintenance
----------------

This fork preserves the original placeholder implementation and adds a per-view
reentrancy guard around placeholder updates. When growing the owning text view
causes synchronous frame/bounds KVO callbacks, nested updates return immediately
instead of recursively resizing the view. The guard is cleared with `@finally`,
so subsequent updates continue normally.

Rendering, attributed placeholders, text-container settings, automatic growth,
scroll tracking, and accessibility retain the upstream behavior. The original
MIT license and attribution are retained.

`Tests/ReentrancyTests.swift` covers a layout callback that restores the owner's
height during resizing. A standalone UIKit comparison on iOS 26.2 observed 20
bounded recursive frame writes in the original implementation versus one in the
patched implementation, with a subsequent update succeeding. The full test
suite has not been rerun for this patch.

Installation
------------

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/gtokman/UITextView-Placeholder.git", branch: "main")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies...
2. Enter `https://github.com/gtokman/UITextView-Placeholder.git`
3. Select the `main` branch (or pin a commit revision) and add to your target


Usage
-----

Import the module and set `placeholder` on your `UITextView`.

- **Objective-C**:

    ```objc
    @import UITextView_Placeholder;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.placeholder = @"How are you?";
    textView.placeholderColor = [UIColor lightGrayColor]; // optional
    textView.attributedPlaceholder = ... // NSAttributedString (optional)
    ```

- **Swift**:

    ```swift
    import UITextView_Placeholder
    
    let textView = UITextView()
    textView.placeholder = "How are you?"
    textView.placeholderColor = UIColor.lightGray // optional
    textView.attributedPlaceholder = ... // NSAttributedString (optional)
    ```

Congratulations! You're done. 🎉


Development
-----------

This project uses [Tuist](https://tuist.io) for project generation.

```bash
# Install Tuist (if not already installed)
curl -Ls https://install.tuist.io | bash

# Generate Xcode project
tuist generate

# Build
tuist build Demo

# Run tests
tuist test

# Run the demo app
tuist run Demo
```


License
-------

UITextView+Placeholder is under MIT license. See the [LICENSE](LICENSE) file for more information.
