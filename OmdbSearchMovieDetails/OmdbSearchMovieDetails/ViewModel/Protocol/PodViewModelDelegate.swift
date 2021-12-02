//
//  ViewModelDelegate.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

public protocol PodViewModelDelegate: AnyObject {
    func didRetrieveSuggestionDetails(suggestion: SuggestionModel)
    func refreshViewContent(navigateToMovieDetailsFlag: Bool)
    func didFailWithError(error: Error)
}
