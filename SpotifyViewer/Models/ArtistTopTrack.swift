//
//  ArtistTrack.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/9/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome
import Realm
import RealmSwift

final class ArtistTopTrack: BaseModel {
    
    dynamic var previewURL = ""
    
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
        
        previewURL = try map.extract("preview_url")
    }
}
