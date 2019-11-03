//
//  Movie.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import Foundation

struct MovieResult: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let posterPath: String?
    let genreIDS: [Int]?
    let title: String?
    let id: Int?
    let overview, releaseDate: String?
    
    var imageURL: URL? {
        if let posterPath = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        } else {
            return nil
        }
    }
    
    var releaseDataString: String? {
        if let releaseDate = releaseDate {
            return "Release \(releaseDate)"
        } else {
            return nil
        }
    }
    
    var genres: [String] {
        return genreIDS?.compactMap { Genre(withId: $0)?.name } ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case title
        case overview
        case releaseDate = "release_date"
    }
}
