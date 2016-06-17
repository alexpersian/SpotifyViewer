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
import RealmSwift
import Realm

enum ArtistResult {
    case Success(Array<SpotifyArtist>)
    case Failure(NSError)
}

enum ImageResult {
    case Success(UIImage)
    case Failure(NSError)
}

enum TrackResult {
    case Success(ArtistTopTrack)
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
                    
                    guard let rawArtists = jsonFromData["artists"]?["items"]?.arrayValue else { print("Failure to parse JSON"); return }
                    
                    for artist in rawArtists {
                        let newArtist = try SpotifyArtist(js: artist)
                        artists.append(newArtist)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.Success(artists))
                    }
                    
                } catch let error {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.Failure(error as NSError))
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
    
    func getArtistTopTrackFromID(artistID: String, completion: TrackResult -> Void) {
        guard let urlString = NSURL(string:"https://api.spotify.com/v1/artists/\(artistID)/top-tracks?country=US") else { return }
        let _ = session.dataTaskWithURL(urlString) { (data, response, error) in
            if let error = error {
                print("Error with data task: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let jsonData = try Json.deserialize(data)
                    guard let track = jsonData["tracks"]?[0] else { print("error parsing json"); return }
                    let artistTopTrack = try ArtistTopTrack(js: track)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.Success(artistTopTrack))
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
