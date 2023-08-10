//
//  ImageListViewTests.swift
//  ImageListViewTests
//
//  Created by Georgy on 10.08.2023.
//

@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    
    final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol{
        var presenter: ImageFeed.ImagesListPresenterProtocol?
        var updateTableViewCalled:Bool = false
        func updateTableViewAnimated(with indexPaths: [IndexPath]) {
            updateTableViewCalled = true
        }
        
        func showAlert() {
            
        }

    }
    
    final class ImagesListPresenterSpy: ImagesListPresenterProtocol{
        var view: ImageFeed.ImagesListViewControllerProtocol?
        var viewDidLoadCalled: Bool = false
        var fetchPhotosDidCalled:Bool = false
        
        func viewDidLoad() {
            viewDidLoadCalled = true
        }
        
        func fetchPhotos() {
            fetchPhotosDidCalled = true
        }
        
        func getCountOfRows() -> Int {
            return 0
        }
        
        func configCell(for cell: ImageFeed.ImagesListCell, with indexPath: IndexPath) {
            
        }
        
        func getCellHeight(for tableViewWidth: CGFloat, with indexPath: IndexPath) -> CGFloat {
            return 0
        }
        
        func shouldUpdateTableView() {
            
        }
        
        func likeButtonTapped(_ cell: ImageFeed.ImagesListCell, for indexPath: IndexPath) {
            
        }
        
        func getImageURL(with indexPath: IndexPath) -> String {
            return ""
        }
    }
    
    func testViewControllerCallsViewDidLoad(){
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testGetCountOfRowsEqualZero(){
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let numberOfRows = presenter.getCountOfRows()
        //then
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testGetCellHeightWithPhoto() {
        // Create a test Photo
        let testPhoto = Photo(
            id: "123",
            size: CGSize(width: 200, height: 300),
            createdAt: nil,
            welcomeDescription: "Test Description",
            thumbImageURL: "https://example.com/thumb.jpg",
            largeImageURL: "https://example.com/large.jpg",
            isLiked: false
        )
        
        // Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.photos.append(testPhoto)
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let cellHeightEqualZero = presenter.getCellHeight(for: 0, with: indexPath)
        let cellHeightPozitive = presenter.getCellHeight(for: 320, with: indexPath)
        let cellHeightNegative = presenter.getCellHeight(for: -1, with: indexPath)
        
        // Then
        XCTAssertEqual(cellHeightEqualZero, 0)
        XCTAssertEqual(cellHeightPozitive, 476)
        XCTAssertEqual(cellHeightNegative, 0)
    }

}
