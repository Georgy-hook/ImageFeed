//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Georgy on 11.08.2023.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func dismissKeyboardIfPresent() {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }
    
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("")
        dismissKeyboardIfPresent()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
        
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    
    func testFeed() throws {
        
        let tableView = app.tables["ImagesList Table View"]
        XCTAssertTrue(tableView.waitForExistence(timeout: 5), "Таблица не была найдена")
        
        
        tableView.swipeDown()
        
        
        let likeButton = tableView.cells.element(boundBy: 0).buttons["like button"]
        
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5), "Кнопка лайка не была найдена")
        likeButton.tap()
        
        likeButton.tap()
        
        
        tableView.cells.element(boundBy: 0).tap()
        
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(3)
        
        XCTAssertTrue(app.staticTexts["Profile name label"].exists)
        XCTAssertTrue(app.staticTexts["Profile link label"].exists)
        
        let logoutButton = app.buttons["Profile logout button"]
        logoutButton.tap()
    }
}
