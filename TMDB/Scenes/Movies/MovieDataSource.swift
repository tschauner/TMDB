//
//  MovieDataSource.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

class MovieDataSource: NSObject {
    
    private var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let movieDataBase = MovieDataBase.shared
    private let retryTimeInterval: TimeInterval = 5
    private let errorLabel = UILabel()
    
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
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        errorLabel.text = "Movies couldn't be parsed"
        errorLabel.isHidden = true
        
        containerView.addSubview(errorLabel)
        errorLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -50).isActive = true
        errorLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let tryAgainButton = UIButton()
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.setTitle("Try again", for: .normal)
        tryAgainButton.setTitleColor(.black, for: .normal)
        tryAgainButton.backgroundColor = .white
        tryAgainButton.layer.cornerRadius = 15
        tryAgainButton.isHidden = true
        tryAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        tryAgainButton.addTarget(self, action: #selector(tryFetchMovies), for: .touchUpInside)
        
        // acitivy indicator will be shown as long as there are no movies available
        // after the timer ends, a retry button with the option to try fetch the movies again shows up
        Timer.scheduledTimer(withTimeInterval: retryTimeInterval, repeats: false) { timer in
            tryAgainButton.isHidden = false
            self.errorLabel.isHidden = false
            self.activityIndicator.stopAnimating()
        }
        
        containerView.addSubview(tryAgainButton)
        tryAgainButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        tryAgainButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 100).isActive = true
        tryAgainButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        tryAgainButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return containerView
    }
    
    @objc private func tryFetchMovies() {
        activityIndicator.startAnimating()
        movieDataBase.fetchMovies()
        errorLabel.isHidden = true
        Timer.scheduledTimer(withTimeInterval: retryTimeInterval, repeats: false) { timer in
            self.errorLabel.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
}

extension MovieDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
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
