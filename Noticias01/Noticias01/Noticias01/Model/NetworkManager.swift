//
//  NetworkManager.swift
//  Noticias01
//
//  Created by Javier on 21/08/23.
//

import Foundation

enum ResultNewsError: Error {
    case badURL, noData, invalidJSON
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    struct Constants {
        static let newsAPI = URL(string: "http://127.0.0.1:8080/home")
    }
    
    private init() { }
    
    func getNews(completion: @escaping (Result<[ResultNews], ResultNewsError>) -> Void) {
        
        // Setup the url
        guard let url = Constants.newsAPI else {
            completion(.failure(.badURL))
            return
        }

        // Create a configuration
        let configuration = URLSessionConfiguration.default

        // Create a session
        let session = URLSession(configuration: configuration)

        // Create the task
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(.failure(.invalidJSON))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ResponseElement.self, from: data)
                completion(.success(result.home.results))
            } catch {
                print("Error info: \(error.localizedDescription)")
                completion(.failure(.noData))
            }
        }
        
        task.resume()
    }
    
}

