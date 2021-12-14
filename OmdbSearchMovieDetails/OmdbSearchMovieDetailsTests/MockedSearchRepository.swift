//
//  MockedSearchRepository.swift
//  OmdbSearchMovieDetailsTests
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation
@testable import OmdbSearchMovieDetails

class MockedSearchRepository: SearchRepositable {
    var shouldFail = false
    var totalResultsMod10Is0 = true
    
    func performRequestWith(title: String, pageNumber: Int, completion: @escaping repositoryResponseBlock) {
        if !shouldFail {
            if totalResultsMod10Is0 {
                let model = SearchModel(results: [Search(title: title, year: "", imdbID: "", type: "", poster: "")], totalResults: "20")
                completion(.success(model))
            } else {
                let model = SearchModel(results: [Search(title: title, year: "", imdbID: "", type: "", poster: "")], totalResults: "24")
                completion(.success(model))
            }
        } else {
            completion(.failure(customError.repositoryError("An error occurred while trying to retrieve data")))
        }
    }
}

enum customError: Error {
    case repositoryError(String)
}
