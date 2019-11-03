//
//  TMDB.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

enum Notifications: String, NotificationName {
    case moviesDidChange
}

class MovieDataBase {
    
    static let shared = MovieDataBase()
    
    var featuredMovie: Movie?
    private var currentPage: Int = 1
    
    var movies: [Movie] = [] {
        didSet {
            if currentPage == 1, let firstMovie = movies.first {
                featuredMovie = firstMovie
                movies.removeAll(where: { $0.id == firstMovie.id })
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
    /// - Parameter completion: optional completion block. will be used when user takes refresh control
    func fetchMovies(forPage page: Int = 1, completion: (() -> Void)? = nil) {
        APIService.shared.request(endpoint: .nowPlaying(page: page)) { (response: Result<MovieResult, APIError>) in
            switch response {
            case .success(let movieResult):
                page == 1
                    ? self.movies = movieResult.results
                    : self.movies.append(contentsOf: movieResult.results)
                
                NotificationCenter.default.post(name: Notifications.moviesDidChange.name, object: nil)
                completion?()
            case .failure:
                completion?()
                DispatchQueue.main.async {
                     // appdelegate must be called on mainthread
                     UIApplication.shared.appDelegate.navigationController.showDefaultAlert()
                }
            }
        }
    }
    
    /// fetch movies with searchString
    func searchMovies(searchSting: String) {
        APIService.shared.request(endpoint: .search(searchSting)) { (response: Result<MovieResult, APIError>) in
            switch response {
            case .success(let movieResult):
                self.filteredMovies = movieResult.results
                NotificationCenter.default.post(name: Notifications.moviesDidChange.name, object: nil)
            case .failure:
                DispatchQueue.main.async {
                     UIApplication.shared.appDelegate.navigationController.showDefaultAlert()
                }
            }
        }
    }
    
    /// fetch all genres
    func fetchGenres() {
        APIService.shared.request(endpoint: .genres) { (response: Result<
            GenreResult, APIError>) in
            switch response {
            case .success(let genresResult):
                self.genres = genresResult.genres
            case .failure:
                DispatchQueue.main.async {
                     UIApplication.shared.appDelegate.navigationController.showDefaultAlert()
                }
            }
        }
    }
}
