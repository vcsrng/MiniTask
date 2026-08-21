//
//  MiniTaskUITests.swift
//  MiniTaskUITests
//
//  Created by Vincent Saranang on 21/08/26.
//

import XCTest

final class MiniTaskUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // Loan list loads and shows the navigation title
    @MainActor
    func testLoanListAppears() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))
    }

    // Portfolio dashboard stat cards appear after data loads
    @MainActor
    func testPortfolioDashboardVisible() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Portfolio Overview"].waitForExistence(timeout: 5))
    }

    // Sort & Filter toolbar button is reachable
    @MainActor
    func testSortFilterButtonExists() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))
        let sortButton = app.buttons["Sort & Filter"]
        XCTAssertTrue(sortButton.waitForExistence(timeout: 3))
    }

    // Filtering by Risk Rating works
    @MainActor
    func testRiskRatingFilter() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))
        let sortButton = app.buttons["Sort & Filter"]
        XCTAssertTrue(sortButton.waitForExistence(timeout: 3))
        sortButton.tap()
        
        let filterOption = app.buttons["A"]
        XCTAssertTrue(filterOption.waitForExistence(timeout: 3))
        filterOption.tap()
        
        let firstCell = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 8))
    }

    // Search bar activates when tapped
    @MainActor
    func testSearchBarActivates() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))
        let searchField = app.searchFields["Search by borrower or purpose"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        searchField.tap()
        XCTAssertTrue(searchField.isSelected || app.keyboards.count > 0)
    }

    // Tapping a loan card navigates to the detail screen
    @MainActor
    func testTapLoanOpensDetail() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))

        // Wait for at least one loan card to appear
        let firstCell = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 8))
        firstCell.tap()

        // Detail screen should show Borrower section
        XCTAssertTrue(app.staticTexts["Borrower"].waitForExistence(timeout: 5))
    }

    // Detail screen shows the Documents navigation row
    @MainActor
    func testDetailShowsDocumentsRow() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))

        let firstCell = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 8))
        firstCell.tap()

        XCTAssertTrue(app.staticTexts["Loan Documents"].waitForExistence(timeout: 5))
    }

    // Navigating into documents screen works
    @MainActor
    func testDocumentsScreenOpens() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))

        let firstCell = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 8))
        firstCell.tap()

        let docsRow = app.staticTexts["Loan Documents"]
        XCTAssertTrue(docsRow.waitForExistence(timeout: 5))
        docsRow.tap()

        XCTAssertTrue(app.navigationBars["Documents"].waitForExistence(timeout: 5))
    }

    // Back navigation returns to loan list
    @MainActor
    func testBackNavigationReturnsToList() throws {
        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))

        let firstCell = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 8))
        firstCell.tap()

        XCTAssertTrue(app.staticTexts["Borrower"].waitForExistence(timeout: 5))
        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertTrue(app.navigationBars["Loans"].waitForExistence(timeout: 5))
    }

    // Launch performance baseline
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
