//
//  MiniTaskUITestsLaunchTests.swift
//  MiniTaskUITests
//
//  Created by Vincent Saranang on 21/08/26.
//

import XCTest

final class MiniTaskUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Wait for the loan list to appear before screenshotting
        _ = app.navigationBars["Loans"].waitForExistence(timeout: 8)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
