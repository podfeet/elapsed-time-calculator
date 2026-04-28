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
        try app.performAccessibilityAudit()
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
        XCTAssertTrue(button.exists)
        button.tap()
        // Explanation text should appear
        let explanation = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'elapsed'")).firstMatch
        XCTAssertTrue(explanation.waitForExistence(timeout: 1),
                      "Explanation text should appear after tapping 'How it works'")
        // Tap again to collapse
        button.tap()
        XCTAssertFalse(explanation.waitForExistence(timeout: 1),
                       "Explanation text should disappear after tapping 'Hide'")
    }

    // MARK: - Add Row

    func testAddRowIncreasesRowCount() {
        let before = app.textFields.matching(NSPredicate(format: "label == 'Hours'")).count
        app.buttons["addRowButton"].tap()
        let after = app.textFields.matching(NSPredicate(format: "label == 'Hours'")).count
        XCTAssertEqual(after, before + 1, "Add Another Row should add exactly one row")
    }

    // MARK: - Reset

    func testResetClearsFields() {
        let hoursField = app.textFields.matching(NSPredicate(format: "label == 'Hours'")).firstMatch
        hoursField.tap()
        hoursField.typeText("5")
        app.buttons["resetButton"].tap()
        XCTAssertEqual(hoursField.value as? String, "",
                       "Reset should clear all field values")
    }
}
