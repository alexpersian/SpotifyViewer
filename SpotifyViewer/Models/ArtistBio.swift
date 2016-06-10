//
//  ArtistBio.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/10/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome

struct ArtistBio: MappableObject {
    
    let bioSummary: String
    let bioContent: String
    
    init(map: Map) throws {
        bioSummary = try map.extract("summary")
        bioContent = try map.extract("content")
    }
    
    func sequence(map: Map) throws {
        try bioSummary ~> map["summary"]
        try bioContent ~> map["content"]
    }
}
