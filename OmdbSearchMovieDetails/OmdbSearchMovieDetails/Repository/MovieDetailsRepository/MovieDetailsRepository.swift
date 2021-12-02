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
        let urlString = "https://www.omdbapi.com/?apikey=335142df&i=\(imdbID)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.serverError))
            }
            do {
                let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data!)
                
                if movieDetails.response == "True" {
                    DispatchQueue.main.async {
                        completion(.success(movieDetails))
                    }
                } else if movieDetails.response == "False" {
                    DispatchQueue.main.async {
                        guard let responseError = movieDetails.error else { return }
                        if responseError == "Incorrect IMDb ID." {
                            completion(.failure(.invalidID))
                        } else if responseError == "Error getting data." {
                            completion(.failure(.IDNotFoundError))
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.parsingError))
                }
            }
        }
        task.resume()
    }
}

public enum APIError: Error {
    case serverError
    case invalidID
    case parsingError
    case IDNotFoundError
}
