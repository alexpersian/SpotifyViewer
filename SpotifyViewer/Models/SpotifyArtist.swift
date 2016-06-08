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
    let artistURI: String
//    let artistPicture: UIImage
//    let artistAlbums: [String]
//    let albumArtwork: [UIImage]
    
    init(map: Map) throws {
        artistName = try map.extract("name")
        artistURI = try map.extract("uri")
    }
    
    func sequence(map: Map) throws {
        try artistName ~> map["name"]
        try artistURI ~> map["uri"]
    }
}
