//
//  LastfmArtist.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/10/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome

struct LastfmArtist: MappableObject {
    
    let artistBio: ArtistBio
    
    init(map: Map) throws {
        artistBio = try map.extract("bio")
    }
    
    func sequence(map: Map) throws {
        try artistBio ~> map["bio"]
    }
}
