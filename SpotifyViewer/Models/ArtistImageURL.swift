//
//  ArtistImage.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/9/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome

struct ArtistImageURL: MappableObject {
    
    let artistImageURL: String
    
    init(map: Map) throws {
        artistImageURL = try map.extract("url")
    }
    
    func sequence(map: Map) throws {
        try artistImageURL ~> map["url"]
    }
}
