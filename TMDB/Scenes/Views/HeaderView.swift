//
//  HeaderView.swift
//  MovieDatabase
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit
import SDWebImage

class HeaderView: UIView {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var onPress: (() -> Void)?
    
    var movie: Movie? {
        didSet {
            if let movie = movie {
                configure(movie: movie)
            }
        }
    }
    
    var isDetailController: Bool = false {
        didSet {
            infoButton.isHidden = isDetailController
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        headerImageView.contentMode = .scaleAspectFill
        
        infoButton.layer.cornerRadius = infoButton.frame.height/2
        infoButton.backgroundColor = .white
        infoButton.setTitle("More Info", for: .normal)
        infoButton.setTitleColor(.black, for: .normal)
        infoButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        insertSubview(verticalGradientView, at: 1)
        verticalGradientView.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor).isActive = true
        verticalGradientView.leftAnchor.constraint(equalTo: headerImageView.leftAnchor).isActive = true
        verticalGradientView.rightAnchor.constraint(equalTo: headerImageView.rightAnchor).isActive = true
        verticalGradientView.topAnchor.constraint(equalTo: headerImageView.topAnchor).isActive = true
    }
    
    @objc private func infoButtonTapped() {
        onPress?()
    }
    
    private func configure(movie: Movie) {
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDataString
        headerImageView.sd_imageTransition = .fade
        headerImageView.sd_setImage(with: movie.imageURL, placeholderImage: nil)
    }
}
