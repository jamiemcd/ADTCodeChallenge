//
//  Cloud+GetEpisodesResponse.swift
//  ADTCodeChallenge
//
//  Created by Jamie McDaniel on 9/8/20.
//  Copyright © 2020 Jamie McDaniel. All rights reserved.
//

import Foundation

extension Cloud {
    
    struct GetEpisodesResponse: Codable {
        let info: Info
        struct Info: Codable {
            let count: Int
            let pages: Int
            let next: String?
            let prev: String?
        }
        
        let results: [Result]
        struct Result: Codable {
            let id: Int
            let name: String
            let airDate: String
            let episode: String
            let characters: [String]
            let url: String
            let created: String
        }
    }
}
