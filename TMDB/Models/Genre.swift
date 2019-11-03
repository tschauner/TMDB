//
//  Genre.swift
//  TMDB
//
//  Created by Philipp Tschauner on 03.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import Foundation

struct GenreResult: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

extension Genre {
    init?(withId id: Int) {
        let genre = MovieDataBase.shared.genres.first(where: { $0.id == id } )
        if let genre = genre {
            self.id = genre.id
            self.name = genre.name
        } else {
            return nil
        }
    }
}
