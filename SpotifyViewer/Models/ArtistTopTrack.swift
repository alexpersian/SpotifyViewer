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
    
    let previewURL: String
    
    init(map: Map) throws {
        previewURL = try map.extract("preview_url")
    }
    
    func sequence(map: Map) throws {
        try previewURL ~> map["preview_url"]
    }
}
