//
//  DataService.swift
//  TMDB
//
//  Created by Philipp Tschauner on 02.11.19.
//  Copyright © 2019 phitsch. All rights reserved.
//

import Foundation
import UIKit

protocol APIProtocol {
    var baseURL: String { get }
    var apiKey: String { get }
    var parameter: String  { get }
    var url: URL? { get }
}

enum APIEndpoint: APIProtocol {
    
    var apiKey: String {
        return "a277803c21540f1dd682f045bf9d6d90"
    }
    
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
    var parameter: String {
        switch self {
        case .search(let searchString):
            return String(format: "&query=%@", searchString)
        case .nowPlaying(page: let page):
            return String(format: "&page=%d", page)
        default:
            return "&language=en-US"
        }
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        case .search:
            return "/search/movie"
        case .genres:
            return "/genre/movie/list"
        }
    }
    
    var url: URL? {
        switch self {
        case .nowPlaying:
            return URL(string: String(format: "%@%@?api_key=%@%@", baseURL, path, apiKey, parameter))
        case.search:
            return URL(string: String(format: "%@%@?api_key=%@%@", baseURL, path, apiKey, parameter))
        case .genres:
            return URL(string: String(format: "%@%@?api_key=%@", baseURL, path, apiKey))
        }
    }
    
    case nowPlaying(page: Int)
    case search(String)
    case genres
}

enum APIError: Error {
    case dataError(Error?)
    case httpError(Error?)
}

class APIService {
    
    static let shared = APIService()
    private let session = URLSession.shared
    
    func request<T: Codable>(endpoint: APIEndpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = endpoint.url else { return }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        session.dataTask(with: request) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(.dataError(error)))
                return
            }
            
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(.failure(.dataError(error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    completion(.failure(.httpError(error)))
                    return
            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            }
            catch {
                debugPrint(error.localizedDescription)
                completion(.failure(.dataError(error)))
            }
            
        }.resume()
        
    }
}
