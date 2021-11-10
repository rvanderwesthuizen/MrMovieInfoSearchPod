//
//  SearchRepositoryTests.swift
//  OmdbSearchMovieDetailsTests
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import XCTest

class SearchRepositoryTests: XCTestCase {
    var implementationUnderTests: MockedSearchRepository!
    override func setUp() {
        implementationUnderTests = MockedSearchRepository()
    }
    
    func testRepositorySuccess() {
        implementationUnderTests.shouldFail = false
        implementationUnderTests.performRequestWith(title: "", pageNumber: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual("20", response.totalResults)
            case .failure(_):
                XCTFail("Repository should not fail")
            }
        }
    }
    
    func testPageNumberIfTotalResultsMod10is0() {
        implementationUnderTests.performRequestWith(title: "", pageNumber: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.numberOfPages, 2)
            case .failure(_):
                XCTFail("Should not fail")
            }
        }
    }
    
    func testPageNumberIfTotalResultsMod10IsNot0() {
        implementationUnderTests.totalResultsMod10Is0 = false
        implementationUnderTests.performRequestWith(title: "", pageNumber: 1) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.numberOfPages, 3)
            case .failure(_):
                XCTFail("Should not fail")
            }
        }
    }
    
    func testRepositoryFailure() {
        implementationUnderTests.shouldFail = true
        implementationUnderTests.performRequestWith(title: "", pageNumber: 1) { result in
            switch result {
            case(.success(_)):
                XCTFail("Repository should not be successful")
            case (.failure(let error)):
                XCTAssertEqual("The operation couldn’t be completed. (OmdbSearchMovieDetailsTests.customError error 0.)", error.localizedDescription)
            }
        }
    }
}

