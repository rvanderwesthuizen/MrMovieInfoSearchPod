//
//  SearchViewModelTests.swift
//  OmdbSearchMovieDetailsTests
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import XCTest
import OmdbSearchMovieDetails

class SearchViewModelTests: XCTestCase {
    private var implementationUnderTest: SearchViewModel!
    private var mockSearchRepository: MockedSearchRepository!
    private var mockedMovieDetailsRepo: MockedMovieDetailsRepository!
    private var mockDelegate: MockDelegate!
    
    override func setUp() {
        mockDelegate = MockDelegate()
        mockSearchRepository = MockedSearchRepository()
        mockedMovieDetailsRepo = MockedMovieDetailsRepository()
        implementationUnderTest = SearchViewModel(searchRepository: mockSearchRepository, delegate: mockDelegate, movieDetailsRepository: mockedMovieDetailsRepo)
    }
    
    func testRetrieveDataSuccess() {
        implementationUnderTest.retrieveData(forTitle: "the flash", page: 1)
        XCTAssertEqual(implementationUnderTest.fetchSearchResult(at: 0)!.title, "the flash")
        XCTAssertTrue(mockDelegate.refreshCalled)
    }
    
    func testRetrieveDataFailure() {
        mockSearchRepository.shouldFail = true
        implementationUnderTest.retrieveData(forTitle: " ", page: 1)
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
    }
    
    func testNumberOfRows() {
        implementationUnderTest.retrieveData(forTitle: "", page: 1)
        XCTAssertEqual(implementationUnderTest.numberOfRows, 1)
    }
    
    func testNumberOfRowsReturn0WhenListIsEmpty() {
        XCTAssertEqual(implementationUnderTest.numberOfRows,0)
    }
    
    func testSearchShouldSucceed() {
        implementationUnderTest.search(forTitle: "")
        XCTAssertTrue(mockDelegate.refreshCalled)
        XCTAssertNotNil(implementationUnderTest.fetchSearchResult(at: 0))
    }
    
    func testSearchShouldFail() {
        mockSearchRepository.shouldFail = true
        implementationUnderTest.search(forTitle: "")
        XCTAssertNil(implementationUnderTest.fetchSearchResult(at: 0))
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
    }
    
    func testFailureWhenIndexDoesNotExist() {
        implementationUnderTest.retrieveData(forTitle: "", page: 1)
        XCTAssertTrue(mockDelegate.refreshCalled)
        XCTAssertNil(implementationUnderTest.fetchSearchResult(at: -1))
    }
    
    func testSuccessWhenIndexDoesExist() {
        implementationUnderTest.retrieveData(forTitle: "", page: 1)
        XCTAssertTrue(mockDelegate.refreshCalled)
        XCTAssertNotNil(implementationUnderTest.fetchSearchResult(at: 0))
    }
    
    func testgetCurrentSearchInfoReturn1ForPageNumberWhenNoCallHasBeenMade() {
        let currentSearchInfo = implementationUnderTest.getCurrentSearchInfo(title: "the flash")!
        XCTAssertEqual(1, currentSearchInfo.pageNumber)
        XCTAssertEqual("the+flash", currentSearchInfo.title)
    }
    
    func testgetCurrentSearchInfoReturn2ForPageNumberWhenOneCallHasBeenMade() {
        let title = "the flash"
        implementationUnderTest.search(forTitle: title)
        let currentSearchInfo = implementationUnderTest.getCurrentSearchInfo(title: title)!
        XCTAssertEqual(currentSearchInfo.pageNumber, 2)
    }
    
    func testRetrieveMovieDetails() {
        implementationUnderTest.search(forTitle: "")
        implementationUnderTest.retrieveMovieDetails(at: 0)
        XCTAssertNotNil(implementationUnderTest.movieDetails)
        XCTAssertTrue(mockDelegate.refreshCalled)
        XCTAssertTrue(mockDelegate.navigationTriggered)
    }
    
    func testRetrieveMovieDetailsIfRepoFails() {
        mockedMovieDetailsRepo.shouldFail = true
        implementationUnderTest.search(forTitle: "")
        implementationUnderTest.retrieveMovieDetails(at: 0)
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
    }
    
    func testRetrieveSuggestionWithoutAnyFailures() {
        mockedMovieDetailsRepo.shouldFail = false
        mockedMovieDetailsRepo.shouldFailToFindID = false
        implementationUnderTest.retrieveSuggestion()
        XCTAssertNotNil(implementationUnderTest.movieDetails)
        XCTAssertTrue(mockDelegate.didRetrieveSuggestionCalled)
    }
    
    func testRetrieveSuggestionWhenRepoFailsAndItIsNotIDNotFoundError() {
        mockedMovieDetailsRepo.shouldFail = true
        implementationUnderTest.retrieveSuggestion()
        XCTAssertNil(implementationUnderTest.movieDetails)
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
    }
    
    func testRetrieveSuggestionWhenRepoFailsWithIDNotFoundError() {
        mockedMovieDetailsRepo.shouldFail = false
        mockedMovieDetailsRepo.shouldFailToFindID = true
        implementationUnderTest.retrieveSuggestion()
        XCTAssertNotNil(implementationUnderTest.movieDetails)
        XCTAssertTrue(mockDelegate.didRetrieveSuggestionCalled)
        XCTAssertFalse(mockDelegate.didFailWithErrorCalled)
    }
    
    class MockDelegate: PodViewModelDelegate {
        var didRetrieveSuggestionCalled = false
        var refreshCalled = false
        var didFailWithErrorCalled = false
        var navigationTriggered = false
        
        func refreshViewContent(navigateToMovieDetailsFlag: Bool) {
            if navigateToMovieDetailsFlag {
                navigationTriggered = navigateToMovieDetailsFlag
            }
            refreshCalled = true
        }
        
        func didFailWithError(error: Error) {
            didFailWithErrorCalled = true
        }
        
        func didRetrieveSuggestion(suggestion: MovieDetails) {
            didRetrieveSuggestionCalled = true
        }
    }
}


