//
//  MovieDataSource.swift
//  MovieDatabase
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

class MovieDataSource: NSObject {
    
    private var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let movieDataBase = MovieDataBase.shared
    
    private var movies: [Movie] {
        return MovieDataBase.shared.movies
    }
    
    private var filterdMovies: [Movie] {
        return MovieDataBase.shared.filteredMovies
    }
    
    private var isSearching: Bool {
        return MovieDataBase.shared.isSearching
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
        
        let tryAgainButton = UIButton()
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.setTitle("Try again", for: .normal)
        tryAgainButton.setTitleColor(.black, for: .normal)
        tryAgainButton.backgroundColor = .white
        tryAgainButton.layer.cornerRadius = 15
        tryAgainButton.isHidden = true
        tryAgainButton.addTarget(self, action: #selector(tryFetchMovies), for: .touchUpInside)
        
        let _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            tryAgainButton.isHidden = false
            self.activityIndicator.stopAnimating()
        }
        
        containerView.addSubview(tryAgainButton)
        
        tryAgainButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        tryAgainButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 100).isActive = true
        tryAgainButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        tryAgainButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        activityIndicator.startAnimating()
        return containerView
    }
    
    @objc private func tryFetchMovies() {
        activityIndicator.startAnimating()
        movieDataBase.fetchMovies()
        let _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            self.activityIndicator.stopAnimating()
        }
    }
    
}

extension MovieDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return movieDataBase.filteredMovies.count
        } else {
            if movies.count == 0 {
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
            MovieDataBase.shared.nextPage()
        }

        let movie = isSearching ? filterdMovies[indexPath.row] : movies[indexPath.row]
        cell.configure(movie: movie)
        
        return cell
    }
    
}
