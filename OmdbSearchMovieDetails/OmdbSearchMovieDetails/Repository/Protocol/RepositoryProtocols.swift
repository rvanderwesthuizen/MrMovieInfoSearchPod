//
//  RepositoryProtocols.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

typealias repositoryResponseBlock = ((Result<SearchModel,Error>) -> Void)
typealias movieDetailsRepositoryResponseBlock = ((Result<MovieDetails,Error>) -> Void)

protocol SearchRepositable {
    func performRequestWith(title: String, pageNumber: Int, completion: @escaping repositoryResponseBlock)
}

protocol MovieDetailRepositable {
    func performRequestWith(imdbID: String, completion: @escaping movieDetailsRepositoryResponseBlock)
}
