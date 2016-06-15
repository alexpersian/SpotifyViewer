//
//  DBManager.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/15/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import Genome
import PureJsonSerializer

extension DBManager {
    
    static var RecentArtistSearches: [SpotifyArtist] {
        return sharedManager.realm
            .objects(SpotifyArtist.self)
            .sorted("createdAt")
            .map { $0 }
    }
}

final class DBManager {
    
    enum Error: ErrorType {
        case UnableToLoadJson
    }
    
    private init() {}
    static let sharedManager = DBManager()
    let realm = try! Realm()
    
    func loadDataFromJSON(json: Json) throws {
        try realm.write {
            realm.deleteAll()
        }
        
        guard let followersJson = json["followers"],
            let artistIdJson = json["id"],
            let imagesJson = json["images"],
            let artistNameJson = json["name"]
        else {
            throw Error.UnableToLoadJson
        }
        
        let followers = try ArtistFollowers(js: followersJson)
        let artistId = artistIdJson.stringValue!
        let imageURLs = try [ArtistImageURL](js: imagesJson)
        let artistName = artistNameJson.stringValue!
        
//        try [followers, artistId, imageURLs, artistName].forEach(save)
    }
    
    func save<T: BaseModel>(objects: [T]) throws {
        try realm.write({ 
            objects.forEach({ (object) in
                object.createOrUpdateInRealm(realm)
            })
        })
    }
    
    func getArtists() -> Results<SpotifyArtist> {
        return realm.objects(SpotifyArtist).sorted("createdAt", ascending: true)
    }
}

extension Realm {
    func createOrUpdate<T: BaseModel>(type: T.Type, withId id: String) -> T {
        return create(T.self, value: ["id": id], update: true)
    }
}
