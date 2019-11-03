//
//  TMDBTests.swift
//  TMDBTests
//
//  Created by Philipp Tschauner on 03.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import XCTest
@testable import TMDB

class TMDBTests: XCTestCase {
    
    let baseURL = "https://api.themoviedb.org/3"
    let apiKey = "a277803c21540f1dd682f045bf9d6d90"
    
    func testApicServiceNowPlayingMovies() {
        let expectation = XCTestExpectation(description: "Download now playing movies")
        APIService.shared.request(endpoint: .nowPlaying(page: 1)) { (response: Result<MovieResult, APIError>) in
            switch response {
            case .success(let movieResult):
                assert(!movieResult.results.isEmpty)
                expectation.fulfill()
            case .failure(let error):
                
                switch error {
                case .httpError(let error):
                    XCTAssertNil(error)
                case .dataError(let error):
                     XCTAssertNil(error)
                }
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testApiServiceGenres() {
        let expectation = XCTestExpectation(description: "Download genres")
        APIService.shared.request(endpoint: .genres) { (response: Result<GenreResult, APIError>) in
            switch response {
            case .success(let genreResult):
                assert(!genreResult.genres.isEmpty)
                expectation.fulfill()
            case .failure(let error):
                
                switch error {
                case .httpError(let error):
                    XCTAssertNil(error)
                case .dataError(let error):
                     XCTAssertNil(error)
                }
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testApiServiceSearch() {
        let expectation = XCTestExpectation(description: "Download genres")
        APIService.shared.request(endpoint: .search("Joker")) { (response: Result<MovieResult, APIError>) in
            switch response {
            case .success(let movieResult):
                assert(movieResult.results.count > 3)
                expectation.fulfill()
            case .failure(let error):
                
                switch error {
                case .httpError(let error):
                    XCTAssertNil(error)
                case .dataError(let error):
                     XCTAssertNil(error)
                }
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testActionGenre() {
        guard let genre = Genre(withId: 28) else { return }
        assert(genre.name == "Action")
    }
    
    func testInitGenre() {
        let genre = Genre(withId: 0)
        XCTAssertNil(genre)
    }

}
