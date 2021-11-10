//
//  ViewModelDelegate.swift
//  OmdbSearchMovieDetails
//
//  Created by Ruan van der Westhuizen on 2021/11/09.
//

import Foundation

public protocol ViewModelDelegate: AnyObject {
    func refreshViewContent(navigateToMovieDetailsFlag: Bool)
    func didFailWithError(error: Error)
}
