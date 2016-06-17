//
//  SpotifyArtist.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/6/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Genome

final class SpotifyArtist: BaseModel {
    
    dynamic var artistName = ""
    dynamic var artistID = ""
    dynamic var artistFollowers: Int = 0
    dynamic var artistImageURLs: ArtistImageURL?
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: AnyObject, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init(map: Map) throws {
        try super.init(map: map)
        
        artistName = try map.extract("name")
        artistID = try map.extract("id")
        artistFollowers = try map.extract("followers.total")
        artistImageURLs = try map.extract("images").first
    }
}
