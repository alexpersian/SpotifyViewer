//
//  ArtistTrack.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/9/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome

struct ArtistTopTrack: MappableObject {
    
    let topTrackURI: String
    
    init(map: Map) throws {
        topTrackURI = try map.extract("uri")
    }
    
    func sequence(map: Map) throws {
        try topTrackURI ~> map["uri"]
    }
}
