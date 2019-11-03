//
//  ViewController+Alert.swift
//  TMDB
//
//  Created by Philipp Tschauner on 03.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withStyle style: UIAlertController.Style, title: String?, message: String?, actions: UIAlertAction..., completion: (() ->Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            actions.forEach { alertController.addAction($0) }
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            self.present(alertController, animated: true, completion: completion)
        }
    }
    
    func showDefaultAlert() {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        UIApplication.shared.appDelegate.navigationController.showAlert(withStyle: .alert, title: nil, message: "Something went wrong. Check your internet connection", actions: okAction, completion: nil)
    }
}
