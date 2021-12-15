//
//  Service.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/12/15.
//

import Foundation

class Service {
    static func performRequest<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void )
    {
        guard let url = url else {
            completion(.failure(APIError.URLError))
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(APIError.serverError))
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data!)
                
                completion(.success(result))
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIError.parsingError))
                }
            }
        }
        task.resume()
    }
}

public enum APIError: Error {
    case ambiguousError
    case URLError
    case serverError
    case invalidID
    case parsingError
    case IDNotFoundError
    case movieNotFoundError
}
