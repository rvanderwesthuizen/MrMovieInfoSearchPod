//
//  SearchViewModel.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

public class SearchViewModel {
    private var movieDetailsRepository: MovieDetailRepositable
    private var searchRepository: SearchRepositable
    private weak var delegate: PodViewModelDelegate?
    private var searchRepositoryResponse: SearchModel?
    private(set) var pageNumber = 1
    private var searchResultsList: [Search] = []
    
    public var movieDetails: MovieDetails?
    
    public init(searchRepository: SearchRepositable = SearchRepository(), delegate: PodViewModelDelegate, movieDetailsRepository: MovieDetailRepositable = MovieDetailsRepository()) {
        self.searchRepository = searchRepository
        self.delegate = delegate
        self.movieDetailsRepository = movieDetailsRepository
    }
    
    public func retrieveSuggestionDetails() {
        var hasSuccessfulResult = false
        let imdbID = "tt\(getRandomNumbers())"
        while hasSuccessfulResult == false {
            movieDetailsRepository.performRequestWith(imdbID: imdbID) {[weak self] result in
                switch result {
                case .success(let response):
                    hasSuccessfulResult = true
                    self?.movieDetails = response
                    let suggestion = SuggestionModel(title: response.title, posterImage: UIImage().loadImage(urlString: response.poster), imdbID: response.imdbID)
                    
                    self?.delegate?.didRetrieveSuggestionDetails(suggestion: suggestion)
                case .failure(_):
                    hasSuccessfulResult = false
                }
            }
        }
    }
    
    private func getRandomNumbers() -> String {
        var numbers = ""
        for _ in 0...6 {
            numbers.append(String(Int.random(in: 0...9)))
        }
        return numbers
    }
    
    public func retrieveMovieDetails(at index: Int) {
        guard let imdbID = fetchSelectedImdbID(at: index) else { return }
        movieDetailsRepository.performRequestWith(imdbID: imdbID) {[weak self] result in
            switch result {
            case .success(let response):
                self?.movieDetails = response
                self?.delegate?.refreshViewContent(navigateToMovieDetailsFlag: true)
            case .failure(let error):
                self?.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    public func retrieveData(forTitle title: String, page: Int) {
        searchRepository.performRequestWith(title: title, pageNumber: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.searchRepositoryResponse = response
                self?.appendToSearchResults(results: response.results)
                self?.delegate?.refreshViewContent(navigateToMovieDetailsFlag: false)
            case .failure(let error):
                self?.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    public func initialSearch(forTitle title: String) {
        searchRepositoryResponse = nil
        searchResultsList.removeAll()
        pageNumber = 1
        search(forTitle: title)
    }
    
    public func search(forTitle title: String) {
        guard let currentSearch = getCurrentSearchInfo(title: title) else { return }
        retrieveData(forTitle: currentSearch.title, page: currentSearch.pageNumber)
    }
    
    public func getCurrentSearchInfo(title: String) -> (title: String, pageNumber: Int)? {
        let titleForSearch = title.replacingOccurrences(of: " ", with: "+")
        guard let numberOfPages = searchRepositoryResponse?.numberOfPages else {
            return (title: titleForSearch, pageNumber: pageNumber) }
        if pageNumber < numberOfPages {
            pageNumber += 1
        } else {
            return nil
        }
        return (title: titleForSearch, pageNumber: pageNumber)
    }
    
    private func appendToSearchResults(results: [Search]) {
        searchResultsList.append(contentsOf: results)
    }
    
    private func fetchSelectedImdbID(at index: Int) -> String? {
        searchResultsList[safe: index]?.imdbID
    }
}

extension SearchViewModel {
    
    public var numberOfRows: Int {
        searchResultsList.count
    }
    
    public func fetchSearchResult(at index: Int) -> Search? {
        searchResultsList[safe: index]
    }
}

