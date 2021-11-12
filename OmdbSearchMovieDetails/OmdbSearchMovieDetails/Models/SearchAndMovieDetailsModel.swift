//
//  SearchAndMovieDetailsModel.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

//MARK: - SearchModel
public struct SearchModel: Codable {
    public let results: [Search]
    public let totalResults: String
    
    public var numberOfPages: Int {
        let number = (Int(totalResults) ?? 0)
        if number % 10 != 0 {
            return number > 0 ? ((number / 10) + 1) : 0
        } else {
            return number > 0 ? (number / 10) : 0
        }
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case results = "Search"
        case totalResults
    }
}

public struct Search: Codable {
    public let title: String
    public let year: String
    public let imdbID: String
    public let type: String
    public let poster: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}

//MARK: - MovieDetails
@objcMembers public class MovieDetails: NSObject, Codable {
    public let title: String
    public let year: String
    public let rated: String
    public let released: String
    public let runtime: String
    public let genre: String
    public let director: String
    public let writer: String
    public let actors: String
    public let plot: String
    public let language: String
    public let awards: String
    public let poster: String
    public let imdbRating: String
    public let imdbID: String
    public let boxOffice: String
    public let type: String
    public let productionStudio: String
    
    public init(title: String, year: String, rated: String, released: String, runtime: String, genre: String, director: String, writer: String, actors: String, plot: String, language: String, awards: String, poster: String, imdbRating: String, imdbID: String, boxOffice: String, type: String, productionStudio: String) {
        self.title = title
        self.year = year
        self.rated = rated
        self.released = released
        self.runtime = runtime
        self.genre = genre
        self.director = director
        self.writer = writer
        self.actors = actors
        self.plot = plot
        self.language = language
        self.awards = awards
        self.poster = poster
        self.imdbRating = imdbRating
        self.imdbID = imdbID
        self.boxOffice = boxOffice
        self.type = type
        self.productionStudio = productionStudio
    }
    
    public var dictionary: [String: String] {
        return ["Title": title,
                "Year": year,
                "Rated": rated,
                "Runtime": runtime,
                "Released": released,
                "Genre": genre,
                "Director": director,
                "Writer": writer,
                "Actors": actors,
                "Plot": plot,
                "Language": language,
                "Awards": awards,
                "Poster": poster,
                "imdbRating": imdbRating,
                "imdbID": imdbID,
                "Type": type,
                "Production": productionStudio,
                "BoxOffice": boxOffice
        ]
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case awards = "Awards"
        case poster = "Poster"
        case imdbRating
        case imdbID
        case type = "Type"
        case productionStudio = "Production"
        case boxOffice = "BoxOffice"
    }
}
