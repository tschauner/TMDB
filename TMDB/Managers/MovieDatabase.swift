//
//  TMDB.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

protocol MovieProtocol: class {
    func moviesUpdated()
    func showErrorAlert(withTitle title: String)
}

class MovieDataBase {
    
    static let shared = MovieDataBase()
    
    weak var delegate: MovieProtocol?
    private var currentPage: Int = 1
    var featuredMovie: Movie?
    
    private(set) var movies: [Movie] = [] {
        didSet {
            if currentPage == 1, let firstMovie = movies.first {
                featuredMovie = firstMovie
                movies.removeAll(where: { $0 == firstMovie })
            }
        }
    }
    
    var filteredMovies: [Movie] = []
    var genres: [Genre] = []

    var isSearching: Bool = false {
        didSet {
            if !isSearching {
                filteredMovies.removeAll()
            }
        }
    }
    
    func nextPage() {
        currentPage += 1
        fetchMovies(forPage: currentPage)
    }
    
    /// fetch nowplaying movies
    /// - Parameter page: default is 1. if the user  takes refresh control default page will be used
    func fetchMovies(forPage page: Int = 1) {
        APIService.shared.request(endpoint: .nowPlaying(page: page)) { [weak self] (response: Result<MovieResult, APIError>) in
            switch response {
            case .success(let movieResult):
                self?.currentPage = page
                page == 1
                    ? self?.movies = movieResult.results
                    : self?.movies.append(contentsOf: movieResult.results)
                 self?.delegate?.moviesUpdated()
            case .failure:
                self?.delegate?.showErrorAlert(withTitle: "Error fetching movies. Please try again.")
            }
        }
    }
    
    /// fetch movies with searchString
    func searchMovies(searchString: String) {
        APIService.shared.request(endpoint: .search(searchString)) { [weak self] (response: Result<MovieResult, APIError>) in
            switch response {
            case .success(let movieResult):
                self?.filteredMovies = movieResult.results
                self?.delegate?.moviesUpdated()
            case .failure:
                 self?.delegate?.showErrorAlert(withTitle: "Error fetching movies. Please try again.")
            }
        }
    }
    
    /// fetch all genres
    func fetchGenres() {
        APIService.shared.request(endpoint: .genres) { [weak self] (response: Result<
            GenreResult, APIError>) in
            switch response {
            case .success(let genresResult):
                self?.genres = genresResult.genres
            case .failure:
                self?.delegate?.showErrorAlert(withTitle: "Error fetching genres. Please try again.")
            }
        }
    }
}
