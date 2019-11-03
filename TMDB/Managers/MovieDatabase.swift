//
//  MovieDatabase.swift
//  MovieDatabase
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
            if let firstMovie = movies.first {
                featuredMovie = firstMovie
                movies.remove(at: 0)
            }
        }
    }
    
    var filteredMovies: [Movie] = []
    var genres: [Genre] = []
    
    var isSearching: Bool = false
    
    func nextPage() {
        currentPage += 1
        fetchMovies(forPage: currentPage)
    }
    
    func fetchMovies(forPage page: Int = 1) {
        APIService.shared.request(endpoint: .nowPlaying(page: page)) { (response: Result<MovieResult, APIError>) in
            switch response {
            case .success(let movies):
                self.movies.append(contentsOf: movies.results)
                NotificationCenter.default.post(name: Notifications.moviesDidChange.name, object: nil)
            case .failure:
                debugPrint("shit happens")
            }
        }
    }
    
    func searchMovies(searchSting: String) {
        APIService.shared.request(endpoint: .search(searchSting)) { (response: Result<MovieResult, APIError>) in
            switch response {
            case .success(let movies):
                self.filteredMovies = movies.results
                NotificationCenter.default.post(name: Notifications.moviesDidChange.name, object: nil)
            case .failure:
                debugPrint("shit happens")
            }
        }
    }
    
    func fetchGenres() {
        APIService.shared.request(endpoint: .genres) { (response: Result<
            GenreResult, APIError>) in
            switch response {
            case .success(let genres):
                self.genres = genres.genres
            case .failure:
                debugPrint("shit happens")
            }
        }
    }
}
