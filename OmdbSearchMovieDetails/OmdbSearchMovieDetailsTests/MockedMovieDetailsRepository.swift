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
    
    func performRequestWith(imdbID: String, completion: @escaping movieDetailsRepositoryResponseBlock) {
        if !shouldFail {
            completion(.success(MovieDetails(title: "", year: "", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", awards: "", poster: "", imdbRating: "", imdbID: "1234", boxOffice: "", type: "", productionStudio: "")))
        } else {
            completion(.failure(customError.repositoryError("An error occurred while trying to retrieve data")))
        }
    }
}
