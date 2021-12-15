//
//  SearchRepository.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

public struct SearchRepository: SearchRepositable {
    public init() {}
    public func performRequestWith(title: String, pageNumber: Int, completion: @escaping repositoryResponseBlock) {
        let url = URL(string: "https://www.omdbapi.com/?apikey=335142df&s=\(title)&page=\(pageNumber)")
        
        Service.performRequest(url: url, expecting: SearchModel.self) { result in
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
                        if response.response == "True" {
                            DispatchQueue.main.async {
                                completion(.success(response))
                            }
                        } else if response.response == "False" {
                            DispatchQueue.main.async {
                                guard let responseError = response.error else { return }
                                switch responseError {
                                case "Too many results." :
                                    completion(.failure(APIError.ambiguousError))
                                case "Incorrect IMDb ID.":
                                    completion(.failure(APIError.invalidID))
                                case "Movie not found!":
                                    completion(.failure(APIError.movieNotFoundError))
                                default:
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
