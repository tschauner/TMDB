//
//  MovieDataSource.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

class MovieDataSource: NSObject {
    
    private let movieDataBase = MovieDataBase.shared
    
    private let loadingBackgroundView: LoadingBackgroundView = {
        guard let backgroundView: LoadingBackgroundView = LoadingBackgroundView.fromNib() else {
            fatalError("failed to load LoadingBackgroundView")
        }
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.errorText = "Movies couldn't be parsed"
        return backgroundView
    }()
    
    private var movies: [Movie] {
        return movieDataBase.movies
    }
    
    private var filteredMovies: [Movie] {
        return movieDataBase.filteredMovies
    }
    
    private var isSearching: Bool {
        return movieDataBase.isSearching
    }
    
    func configure(tableView: UITableView) {
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
    
    private func backgroundView(for tableView: UITableView) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        containerView.addSubview(loadingBackgroundView)
        loadingBackgroundView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        loadingBackgroundView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        loadingBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        loadingBackgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        return containerView
    }
    
    @objc private func tryFetchMovies() {
        movieDataBase.fetchMovies()
        loadingBackgroundView.retry()
    }
}

extension MovieDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            tableView.backgroundView = nil
            return filteredMovies.count
        } else {
            if movies.isEmpty {
                tableView.backgroundView = backgroundView(for: tableView)
                return 0
            } else {
                tableView.backgroundView = nil
                return movies.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { fatalError("failed to load MovieTableViewCell")}
        
        if indexPath.row == movies.count - 5 {
            movieDataBase.nextPage()
        }

        let movie = isSearching ? filteredMovies[indexPath.row] : movies[indexPath.row]
        cell.configure(movie: movie)
        
        return cell
    }
}
