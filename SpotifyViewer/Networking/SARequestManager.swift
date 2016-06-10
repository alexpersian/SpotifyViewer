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

enum ArtistResult {
    case Success(Array<SpotifyArtist>)
    case Failure(NSError)
}

enum ImageResult {
    case Success(UIImage)
    case Failure(NSError)
}

class SARequestManager: NSObject {
    
    static let sharedManager = SARequestManager()
    private override init() {}
    
    private let session: NSURLSession = {
        let sessionCongig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionCongig)
        return session
    }()
    
    func getArtistsWithQuery(query: String, completion: ArtistResult -> Void) {
        
        let queryString = query.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        guard let spotifyWebAPIURL = NSURL(string: "https://api.spotify.com/v1/search?q=\(queryString)&type=artist") else {
            print("Error parsing Spotify URL")
            return
        }
        
        let _ = session.dataTaskWithURL(spotifyWebAPIURL) { (data, response, error) in
            if let error = error {
                print("Error with data task: \(error)")
            } else if let data = data {
                do {
                    
                    var artists = [SpotifyArtist]()
                    let jsonFromData = try Json.deserialize(data)
                    
                    guard let rawArtists = jsonFromData["artists"]?["items"] else { print("Failure to parse JSON"); return }
                    
                    for artist in rawArtists.arrayValue! {
                        let newArtist = try SpotifyArtist(js: artist)
                        artists.append(newArtist)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.Success(artists))
                    }
                    
                } catch let error as NSError {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.Failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func getArtistImageFromURL(imageURL: String, completion: ImageResult -> Void) {
        guard let spotifyImageURL = NSURL(string: imageURL) else { return }
        let _ = session.dataTaskWithURL(spotifyImageURL) { (data, response, error) in
            if let error = error {
                completion(.Failure(error))
            } else if let data = data {
                guard let image = UIImage(data: data) else { print("image process failed"); return }
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.Success(image))
                }
            }
        }.resume()
    }
    
    func getArtistTopTracksFromID(artistID: String,
                                  success: (topTracks: Array<ArtistTopTrack>) -> (),
                                  failure: (error: NSError) -> ()) {
        
    }
}
