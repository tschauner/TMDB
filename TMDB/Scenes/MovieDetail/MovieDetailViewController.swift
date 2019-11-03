//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by Philipp Tschauner on 03.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var headerContainerView: UIView!
    
    private let headerview: HeaderView = {
        guard let headerView: HeaderView = HeaderView.fromNib() else {
            fatalError("failed to load HeaderView")
        }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.isDetailController = true
        return headerView
    }()
    
    let movie: Movie
    
    init(withMovie movie: Movie) {
        self.movie = movie
        self.headerview.movie = movie
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.text = movie.overview
        descriptionTextView.textColor = .white
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        descriptionTextView.showsVerticalScrollIndicator = false
        
        genreLabel.textColor = .white
        genreLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        genreLabel.textAlignment = .center
        genreLabel.text = movie.genres.joined(separator: " ♦️ ")
        
        headerContainerView.addSubview(headerview)
        headerview.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        headerview.leftAnchor.constraint(equalTo: headerContainerView.leftAnchor).isActive = true
        headerview.rightAnchor.constraint(equalTo: headerContainerView.rightAnchor).isActive = true
        headerview.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
    }
}
