//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Georgy on 09.08.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    let profileExample = Profile(username: "test",
                                 name: "test",
                                 loginName: "test",
                                 bio: "test")
    
    final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
        var presenter: ImageFeed.ProfileViewPresenterProtocol?
        var updateProfileDetailsCalled = false
        func switchToAuthViewController() {
            
        }
        
        func updateProfileDetails(profile: ImageFeed.Profile) {
            updateProfileDetailsCalled = true
        }
        
        
    }
    
    final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
        var view: ImageFeed.ProfileViewControllerProtocol?
        var viewDidLoadCalled: Bool = false
        
        func didExitButtonClicked() {
            
        }
        
        func viewDidLoad() {
            viewDidLoadCalled = true
        }
        
        func getImageUrl() -> URL? {
            return nil
        }
    }
    
    func testViewControllerCallsViewDidLoad(){
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    func testPresenterCallsUpdateProfile(){
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.updateProfileDetails(profile: profileExample)
        
        //then
        XCTAssertTrue(viewController.updateProfileDetailsCalled) //behaviour verification
    }
}
