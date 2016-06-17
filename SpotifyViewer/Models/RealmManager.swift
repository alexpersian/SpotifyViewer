//
//  RealmManager.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/16/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome
import PureJsonSerializer
import RealmSwift
import Realm

class RealmManager {
    
    private init() {}
    static let sharedManager = RealmManager()
    let realm = try! Realm()
    
    func save<T: BaseModel>(objects: [T]) throws {
        try realm.write({
            objects.forEach({ (object) in
                object.createOrUpdateInRealm(realm)
            })
        })
    }
    
    func getArtists() -> Results<SpotifyArtist> {
        return realm.objects(SpotifyArtist).sorted("createdAt", ascending: false)
    }
}
