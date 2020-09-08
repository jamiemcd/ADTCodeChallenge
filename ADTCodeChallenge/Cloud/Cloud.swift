//
//  Cloud.swift
//  ADTCodeChallenge
//
//  Created by Jamie McDaniel on 9/8/20.
//  Copyright © 2020 Jamie McDaniel. All rights reserved.
//

import Foundation

class Cloud {
    
    // MARK: Internal Properties
    
    enum CloudError: Error {
        case noResponse(Error)
        case decodingResponseError(Error)
        case server(httpStatusCode: Int)
    }
    
    

    // MARK: Private Properties
    
    lazy var urlSession: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    // MARK: Init / Deinit
    
    // MARK: Public Methods
    
    func getEpisodes(_ completionHandler: @escaping (Result<GetEpisodesResponse, CloudError>) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/episode/")!
        let urlRequest = URLRequest(url: url)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if let error = error {
                DispatchQueue.main.async {completionHandler(.failure(.noResponse(error))) }
                return
            }
            
            let httpURLResponse = urlResponse as! HTTPURLResponse
            if httpURLResponse.statusCode == 200, let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let getEpisodesResponse = try jsonDecoder.decode(GetEpisodesResponse.self, from: data)
                    DispatchQueue.main.async { completionHandler(.success(getEpisodesResponse)) }
                    return
                }
                catch {
                    DispatchQueue.main.async { completionHandler(.failure(.decodingResponseError(error))) }
                    return
                }
            }
            DispatchQueue.main.async { completionHandler(.failure(.server(httpStatusCode: httpURLResponse.statusCode))) }
            return
        }
        dataTask.resume()
        
    }
    
    
    // MARK: Private Methods
    
    
}


// MARK: - Extension for Protocol conformance
