//
//  MovieViewController.swift
//  MovieDatabase
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private let searchBar = UISearchBar()
    private let movieDataBase = MovieDataBase.shared
    
    private var isSearching: Bool = false {
        didSet {
            movieDataBase.isSearching = isSearching
            tableView.contentInsetAdjustmentBehavior = isSearching ? .always : .never
        }
    }

    private var movieDataSource: MovieDataSource? {
        didSet {
            if isViewLoaded {
                movieDataSource?.configure(tableView: tableView)
            }
        }
    }
    
    private let verticalGradientView: VerticalGradientView = {
        let gradientView = VerticalGradientView()
        gradientView.startPosition = 0.5
        gradientView.endPosition = 1
        gradientView.startColor = UIColor.black.withAlphaComponent(0.2)
        gradientView.endColor = .black
        gradientView.backgroundColor = .clear
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        movieDataSource = MovieDataSource()
        tableView.dataSource = movieDataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for movies"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviesDidChange), name: Notifications.moviesDidChange.name, object: nil)
    }
        
    private func setupNavigationBar() {
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "magnifier"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func searchButtonTapped() {
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        isSearching = true
        tableView.reloadData()
    }
    
    private func search(movies: String) {
        movieDataBase.searchMovies(searchSting: movies)
    }
    
    @objc private func moviesDidChange() {
        tableView.reloadData()
    }
    
    private func showDetailController(forMovie movie: Movie) {
        searchBar.resignFirstResponder()
        let controller = MovieDetailViewController(withMovie: movie)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MovieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(movies: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
        navigationItem.titleView = nil
        tableView.reloadData()
    }
    
}

extension MovieViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MovieDataBase.shared.featuredMovie == nil || movieDataBase.isSearching  ? 0 : 270
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let movie = movieDataBase.featuredMovie else {
            return nil
        }
        let headerView: HeaderView = HeaderView.fromNib()
        headerView.movie = movie
        headerView.onPress = { [weak self] in
            self?.showDetailController(forMovie: movie)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = isSearching ? movieDataBase.filteredMovies[indexPath.row] : movieDataBase.movies[indexPath.row]
        showDetailController(forMovie: movie)
    }
}