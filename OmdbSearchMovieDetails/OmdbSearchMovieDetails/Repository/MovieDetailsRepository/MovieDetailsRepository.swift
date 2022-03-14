//
//  MovieDetailsRepository.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

public struct MovieDetailsRepository: MovieDetailRepositable {
    public init() {}
    public func performRequestWith(imdbID: String, completion: @escaping movieDetailsRepositoryResponseBlock) {
        let url = URL(string: "https://www.omdbapi.com/?apikey=335142df&i=\(imdbID)")
        
        Service.performRequest(url: url, expecting: MovieDetails.self) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error as! APIError))
            case .success(let response):
                if response.response == "True" {
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } else if response.response == "False" {
                    DispatchQueue.main.async {
                        guard let responseError = response.error else { return }
                        if responseError == "Incorrect IMDb ID." {
                            completion(.failure(APIError.invalidID))
                        } else if responseError == "Error getting data." {
                            completion(.failure(APIError.IDNotFoundError))
                        }
                    }
                }
            }
        }
    }
}
