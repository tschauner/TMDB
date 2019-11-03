//
//  TMDBTests.swift
//  TMDBTests
//
//  Created by Philipp Tschauner on 03.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import XCTest


class TMDBTests: XCTestCase {
    

    let baseURL = "https://api.themoviedb.org/3"
    let apiKey = "a277803c21540f1dd682f045bf9d6d90"
    
    func testUpcomingMovies() {
        let expectation = XCTestExpectation(description: "Download upcoming movies")
        let url = URL(string: String(format: "%@/movie/now_playing?api_key=%@&%@", baseURL, apiKey, "page=1"))!
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            XCTAssertNotNil(data, "No data was downloaded.")
            expectation.fulfill()
        }

        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGenres() {
        let expectation = XCTestExpectation(description: "Download genres")
        let url = URL(string: String(format: "%@/genre/movie/list?api_key=%@", baseURL, apiKey))!
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            XCTAssertNotNil(data, "No data was downloaded.")
            expectation.fulfill()
        }

        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
        
    }

}
