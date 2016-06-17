//
//  BaseModel.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/15/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Genome
import PureJsonSerializer

class BaseModel: RealmSwift.Object, MappableObject {
    
    dynamic var id: String = ""
    dynamic var createdAt = NSDate()
    dynamic var updatedAt = NSDate()
    
    required init() {
        super.init()
    }
    
    required init(map: Map) throws {
        super.init()
        
        id = try map.extract("id") ?? String().randomAlphaNumericString(10)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: AnyObject, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func newInstance(json: Json, context: Context = EmptyJson) throws -> Self {
        let map = Map(json: json, context: context)
        let new = try self.init(map: map)
        return new
    }
    
    func createOrUpdateInRealm(realm: Realm) {
        realm.create(self.dynamicType, value: self, update: true)
    }
}
