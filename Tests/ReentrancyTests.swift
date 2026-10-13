import UIKit
import XCTest
import UITextView_Placeholder

final class ReentrancyTests: XCTestCase {
    @MainActor
    func testFrameObservationDoesNotRecursivelyResizeTheOwner() {
        let textView = LayoutRestoringTextView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        textView.font = .systemFont(ofSize: 20)
        textView.placeholder = "Ready"
        textView.restoresHeight = true
        textView.placeholder = String(repeating: "Long placeholder ", count: 20)
        XCTAssertLessThan(textView.frameWriteCount, 5)

        textView.restoresHeight = false
        textView.placeholder = "Next update"
        XCTAssertEqual(textView.placeholderTextView.text, "Next update")
        XCTAssertGreaterThan(textView.frame.height, 1)
    }
}

@MainActor
private final class LayoutRestoringTextView: UITextView {
    var restoresHeight = false
    var frameWriteCount = 0

    override var frame: CGRect {
        get { super.frame }
        set {
            var frame = newValue
            if restoresHeight {
                frameWriteCount += 1
                // Bound the original implementation's recursion so a regression
                // fails the assertion instead of overflowing the test's stack.
                if frameWriteCount < 20 { frame.size.height = 1 }
            }
            super.frame = frame
        }
    }
}
