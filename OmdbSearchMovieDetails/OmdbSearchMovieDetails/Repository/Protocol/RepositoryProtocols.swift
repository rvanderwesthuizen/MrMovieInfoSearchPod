//
//  RepositoryProtocols.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

public typealias repositoryResponseBlock = ((Result<SearchModel,Error>) -> Void)
public typealias movieDetailsRepositoryResponseBlock = ((Result<MovieDetails,Error>) -> Void)

public protocol SearchRepositable {
    func performRequestWith(title: String, pageNumber: Int, completion: @escaping repositoryResponseBlock)
}

public protocol MovieDetailRepositable {
    func performRequestWith(imdbID: String, completion: @escaping movieDetailsRepositoryResponseBlock)
}
