//
//  AppDelegate.swift
//  MovieDatabase
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window = window else { return false }
        
        MovieDataBase.shared.fetchMovies()
        MovieDataBase.shared.fetchGenres()
        applyAppeareance()
        
        window.rootViewController = UINavigationController(rootViewController: MovieViewController())
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func applyAppeareance() {
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).isTranslucent = true
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).shadowImage = UIImage()
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).tintColor = .white
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).backgroundColor = .clear
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).barStyle = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

}

