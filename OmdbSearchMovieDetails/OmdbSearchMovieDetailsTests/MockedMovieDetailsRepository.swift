//
//  MockedMovieDetailsRepository.swift
//  OmdbSearchMovieDetailsTests
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation
@testable import OmdbSearchMovieDetails

class MockedMovieDetailsRepository: MovieDetailRepositable {
    var shouldFail = false
    var shouldFailToFindID = false
    
    func performRequestWith(imdbID: String, completion: @escaping movieDetailsRepositoryResponseBlock) {
        if !shouldFail {
            if !shouldFailToFindID {
                completion(.success(MovieDetails(title: "", year: "", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", awards: "", poster: "", imdbRating: "", imdbID: "1234", boxOffice: "", type: "", productionStudio: "", error: "", response: "")))
            } else {
                shouldFailToFindID = false
                completion(.failure(.IDNotFoundError))
            }
        } else {
            completion(.failure(.serverError))
        }
    }
}
