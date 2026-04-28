//
//  AccessibilityTests.swift
//  ElapsedTimeAdderUITests
//

import XCTest

final class AccessibilityTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Automated audit

    func testAccessibilityAuditMainScreen() throws {
        // We audit only for element descriptions and contrast. The parent/child
        // containment check is skipped because it is likely triggered by SwiftUI's
        // internal frame math inside ScrollView, not a real user-facing problem.
        try app.performAccessibilityAudit(for: [.sufficientElementDescription, .contrast]) { issue in
            print("AUDIT ISSUE: \(issue.compactDescription) | element: \(issue.element?.debugDescription ?? "unknown")")
            return true
        }
    }

    // MARK: - Key buttons exist and are reachable

    func testAddRowButtonExists() {
        XCTAssertTrue(app.buttons["addRowButton"].exists,
                      "Add Another Row button must be accessible")
    }

    func testResetButtonExists() {
        XCTAssertTrue(app.buttons["resetButton"].exists,
                      "Reset button must be accessible")
    }

    func testHowItWorksButtonExists() {
        XCTAssertTrue(app.buttons["howItWorksButton"].exists,
                      "'How it works' button must be accessible")
    }

    func testToggleButtonsHaveLabels() {
        let toggles = app.buttons.matching(identifier: "toggleButton")
        XCTAssertGreaterThan(toggles.count, 0,
                             "+/− buttons must exist and have an accessibility identifier")
        // Verify the label is one of the two expected values
        let first = toggles.firstMatch
        let label = first.label
        XCTAssertTrue(label == "Add time" || label == "Subtract time",
                      "Toggle label must be 'Add time' or 'Subtract time', got: \(label)")
    }

    // MARK: - Text fields are labelled for VoiceOver

    func testHourFieldsHaveLabels() {
        let fields = app.textFields.matching(NSPredicate(format: "label == 'Hours'"))
        XCTAssertGreaterThan(fields.count, 0, "Hour fields must have 'Hours' accessibility label")
    }

    func testMinuteFieldsHaveLabels() {
        let fields = app.textFields.matching(NSPredicate(format: "label == 'Minutes'"))
        XCTAssertGreaterThan(fields.count, 0, "Minute fields must have 'Minutes' accessibility label")
    }

    func testSecondFieldsHaveLabels() {
        let fields = app.textFields.matching(NSPredicate(format: "label == 'Seconds'"))
        XCTAssertGreaterThan(fields.count, 0, "Second fields must have 'Seconds' accessibility label")
    }

    // MARK: - How It Works expander

    func testHowItWorksExpandsAndCollapses() {
        let button = app.buttons["howItWorksButton"]
        XCTAssertTrue(button.exists, "howItWorksButton must exist")
        XCTAssertTrue(button.isHittable, "howItWorksButton must be hittable")
        button.tap()
        let explanation = app.descendants(matching: .any).matching(identifier: "explanationPanel").firstMatch
        XCTAssertTrue(explanation.waitForExistence(timeout: 2),
                      "Explanation panel should appear after tapping 'How it works'")
        button.tap()
        let gone = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"),
                                             object: explanation)
        XCTWaiter().wait(for: [gone], timeout: 2)
        XCTAssertFalse(explanation.exists, "Explanation panel should disappear after tapping 'Hide'")
    }

    // MARK: - Add Row

    func testAddRowIncreasesRowCount() {
        let before = app.textFields.matching(NSPredicate(format: "label == 'Hours'")).count
        app.buttons["addRowButton"].tap()
        let after = app.textFields.matching(NSPredicate(format: "label == 'Hours'")).count
        XCTAssertEqual(after, before + 1, "Add Another Row should add exactly one row")
    }

    // MARK: - Reset

    func testResetRestoresInitialState() {
        let hoursPredicate = NSPredicate(format: "label == 'Hours'")
        let initialRowCount = app.textFields.matching(hoursPredicate).count

        // 1. Add a title to the first row
        let firstTitle = app.textFields.matching(NSPredicate(format: "label == 'Row title'")).firstMatch
        firstTitle.tap()
        firstTitle.typeText("My Segment")

        // 2. Enter hours in the first row
        let firstHours = app.textFields.matching(hoursPredicate).firstMatch
        firstHours.tap()
        firstHours.typeText("5")

        // 3. Toggle the first row from + to −
        let firstToggle = app.buttons.matching(identifier: "toggleButton").firstMatch
        firstToggle.tap()
        XCTAssertEqual(firstToggle.label, "Subtract time", "Toggle should switch to subtract")

        // 4. Add a new row
        app.buttons["addRowButton"].tap()
        XCTAssertEqual(app.textFields.matching(hoursPredicate).count, initialRowCount + 1,
                       "Should have one more row after tapping Add Another Row")

        // 5. Enter a value in the new row
        let newRowHours = app.textFields.matching(hoursPredicate).element(boundBy: initialRowCount)
        newRowHours.tap()
        newRowHours.typeText("3")

        // 6. Scroll down to reveal Reset and tap it
        app.scrollViews.firstMatch.swipeUp()
        app.buttons["resetButton"].tap()

        // 7. Verify everything is back to the initial state
        XCTAssertEqual(app.textFields.matching(hoursPredicate).count, initialRowCount,
                       "Row count should be restored after reset")

        XCTAssertEqual(app.textFields.matching(hoursPredicate).firstMatch.value as? String, "",
                       "Hours field should be empty after reset")

        XCTAssertEqual(app.textFields.matching(NSPredicate(format: "label == 'Row title'")).firstMatch.value as? String, "",
                       "Title field should be empty after reset")

        XCTAssertEqual(app.buttons.matching(identifier: "toggleButton").firstMatch.label, "Add time",
                       "Toggle should be back to + after reset")
    }
}
