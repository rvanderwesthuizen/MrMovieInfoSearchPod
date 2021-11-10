//
//  SearchRepository.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

public struct SearchRepository: SearchRepositable {
    public func performRequestWith(title: String, pageNumber: Int, completion: @escaping repositoryResponseBlock) {
        let urlString = "https://www.omdbapi.com/?apikey=335142df&s=\(title)&page=\(pageNumber)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
            }
            do {
                let searchResults = try JSONDecoder().decode(SearchModel.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(searchResults))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
