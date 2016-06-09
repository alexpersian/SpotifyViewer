//
//  SpotifyArtist.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/6/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome

struct SpotifyArtist: MappableObject {
    
    let artistName: String
    let artistID: String
    var artistFollowers: Follower
    let artistImageURLs: [ArtistImageURL]?
    
    init(map: Map) throws {
        artistName = try map.extract("name")
        artistID = try map.extract("id")
        artistFollowers = try map.extract("followers")
        artistImageURLs = try map.extract("images")
    }
    
    func sequence(map: Map) throws {
        try artistName ~> map["name"]
        try artistID ~> map["id"]
        try artistFollowers ~> map["followers"]
        try artistImageURLs ~> map["images"]
    }
}
