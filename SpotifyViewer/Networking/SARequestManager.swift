//
//  SARequestManager.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/6/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import Genome
import PureJsonSerializer

class SARequestManager: NSObject {
    
    static let sharedManager = SARequestManager()
    private override init() {}
    
    private let session: NSURLSession = {
        let sessionCongig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionCongig)
        return session
    }()
    
    func getArtistsWithQuery(query: String,
                             success: (artists: Array<SpotifyArtist>) -> (),
                             failure: (error: NSError) -> ()) {
        
        let queryString = query.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        guard let spotifyWebAPIURL = NSURL(string: "https://api.spotify.com/v1/search?q=\(queryString)&type=artist") else { print("Error parsing Spotify URL"); return }
        
        let task = session.dataTaskWithURL(spotifyWebAPIURL) { (data, response, error) in
            
            if let error = error {
                print("Error with data task: \(error)")
            } else if let data = data {
                do {
                    var artists = [SpotifyArtist]()
                    let jsonFromData = try Json.deserialize(data)
                    
                    
                    guard let rawArtists = jsonFromData["artists"]?["items"] else { print("Failure to parse JSON"); return }
                    
                    for artist in rawArtists.arrayValue! {
                        let newArtist = try SpotifyArtist(js: artist)
                        print(newArtist)
                        artists.append(newArtist)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        success(artists: artists)
                    }
                    
                } catch let error as NSError {
                    dispatch_async(dispatch_get_main_queue()) {
                        failure(error: error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func getArtistsWithCompletion(completion: () -> ()) {
        
    }
}
