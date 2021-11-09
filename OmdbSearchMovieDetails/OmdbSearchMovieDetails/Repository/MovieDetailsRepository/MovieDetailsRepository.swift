//
//  MovieDetailsRepository.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

struct MovieDetailsRepository: MovieDetailRepositable {
    func performRequestWith(imdbID: String, completion: @escaping movieDetailsRepositoryResponseBlock) {
        let urlString = "https://www.omdbapi.com/?apikey=335142df&i=\(imdbID)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(error!))
            }
            do {
                let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(movieDetails))
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
