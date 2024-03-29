//
//  MovieTableViewCell.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        titleLabel.textColor = .white
        subtitleLabel.textColor = .white
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 3
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        overviewLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        moreLabel.text = "More Info"
        moreLabel.textColor = .red
        moreLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        subtitleLabel.text = movie.releaseDataString
        overviewLabel.text = movie.overview
        
        movieImageView.sd_imageTransition = .fade
        movieImageView.sd_setImage(with: movie.imageURL, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        subtitleLabel.text = nil
        overviewLabel.text = nil
        movieImageView.image = nil
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        backgroundColor = highlighted ? UIColor(white: 0.1, alpha: 1) : .clear
    }
}
