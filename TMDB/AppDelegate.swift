//
//  AppDelegate.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let navigationController = UINavigationController(rootViewController: MovieViewController())
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window = window else { return false }
        
        applyAppeareance()
        MovieDataBase.shared.fetchGenres()
        MovieDataBase.shared.fetchMovies()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func applyAppeareance() {
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).isTranslucent = true
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).shadowImage = UIImage()
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).tintColor = .white
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).barStyle = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

}

extension UIApplication {
    
    var appDelegate: AppDelegate {
        return delegate as! AppDelegate
    }
}

