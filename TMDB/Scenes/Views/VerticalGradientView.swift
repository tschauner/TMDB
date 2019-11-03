//
//  VerticalGradientView.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

@IBDesignable
class VerticalGradientView: UIView {
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    @IBInspectable var startPosition: Float = 0.0
    @IBInspectable var endPosition: Float = 1.0

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
        return gradientLayer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient()
    }

    private func updateGradient() {
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [NSNumber(value: startPosition), NSNumber(value: endPosition)]
    }
}
