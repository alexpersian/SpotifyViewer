//
//  LFRequestManager.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/10/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome
import PureJsonSerializer

enum LFArtistResult {
    case Success(ArtistBio)
    case Failure(NSError)
}

class LFRequestManager: NSObject {

    static let sharedManager = LFRequestManager()
    private override init() {}
    let kLastfmAPIKey = "398f3cab89213100fcf2358abb460bb1"
    
    private let session: NSURLSession = {
        let sessionCongig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionCongig)
        return session
    }()
    
    func getArtistBioWithQuery(query: String, completion: LFArtistResult -> Void) {
        let queryString = query.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        guard let lastfmWebAPIURL = NSURL(string: "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=\(queryString)&api_key=\(kLastfmAPIKey)&format=json") else {
            print("shit;s fucked up yo")
            return
        }
        
        let _ = session.dataTaskWithURL(lastfmWebAPIURL) { (data, response, error) in
            if let error = error {
                print("Error with data task: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let jsonData = try Json.deserialize(data)
                    guard let bio = jsonData["artist"]?["bio"] else { print("error parsing json"); return }
                    let artistBio = try ArtistBio(js: bio)
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        completion(.Success(artistBio))
                    }
                } catch let error as NSError {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        completion(.Failure(error))
                    }
                }
            }
        }.resume()
    }
}
