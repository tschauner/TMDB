//
//  BackgroundView.swift
//  TMDB
//
//  Created by Philipp Tschauner on 03.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

class LoadingBackgroundView: UIView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    private let retryTimeInterval: TimeInterval = 5
    
    var errorText: String? {
        didSet {
            errorLabel.text = errorText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicatorView.hidesWhenStopped = true
        
        errorLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        errorLabel.isHidden = true
        
        retryButton.setTitle("Try again", for: .normal)
        retryButton.setTitleColor(.black, for: .normal)
        retryButton.backgroundColor = .white
        retryButton.layer.cornerRadius = 15
        retryButton.isHidden = true
        retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        retryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)
        
        startTimer()
        
        activityIndicatorView.startAnimating()
    }
    
    @objc func retry() {
        errorLabel.isHidden = true
        retryButton.isHidden = true
        activityIndicatorView.startAnimating()
        startTimer()
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: retryTimeInterval, repeats: false) { timer in
            self.errorLabel.isHidden = false
            self.retryButton.isHidden = false
            self.activityIndicatorView.stopAnimating()
        }
    }
    
}
