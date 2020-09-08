//
//  Episode.swift
//  ADTCodeChallenge
//
//  Created by Jamie McDaniel on 9/8/20.
//  Copyright © 2020 Jamie McDaniel. All rights reserved.
//

import Foundation

struct Episode: Hashable {
    let id: Int
    let name: String
    let airDate: String
    let characters: [String] = []
    let url: URL
    let creationDate: Date
    let shortName: String
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    static func makeEpisodes(_ getEpisodesResponse: Cloud.GetEpisodesResponse) -> [Episode] {
        var episodes: [Episode] = []
        for result in getEpisodesResponse.results {
            if let url = URL(string: result.url), let creationDate = dateFormatter.date(from: result.created) {
                
                let episode = Episode(id: result.id, name: result.name, airDate: result.airDate, url: url, creationDate: creationDate, shortName: result.episode)
                episodes.append(episode)
            }
        }
        return episodes
    }
}



    

