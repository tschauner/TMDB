//
//  Notification+Name.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import Foundation

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}
