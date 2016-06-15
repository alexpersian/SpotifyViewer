//
//  ArtistBio.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/10/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome
import Realm
import RealmSwift

final class ArtistBio: BaseModel {
    
    dynamic var bioSummary = ""
    dynamic var bioContent = ""
    
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
        
        bioSummary = try map.extract("summary")
        bioContent = try map.extract("content")
    }
}
