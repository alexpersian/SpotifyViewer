//
//  LoginViewController.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/7/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    let kClientId = "5d6321d41dc9487189b7f0b28a585190"
    let kRedirectURL = "intrepid-spotify-viewer-login://callback"
    
    var spotifyArtists: [SpotifyArtist]!
    
    @IBAction func loginToSpotify(sender: UIButton) {
        
        SARequestManager.sharedManager.getArtistsWithQuery("Porter Robinson", success:
        { (artists) in
            print(artists)
            self.spotifyArtists = artists })
        { (error) in
            print(error) }
        
        self.performSegueWithIdentifier("LoginToSearchSegue", sender: sender)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoginToSearchSegue") {
            guard let searchVC = segue.destinationViewController as? SearchViewController else { return }
            searchVC.spotifySession = SPTSession()
            searchVC.spotifyArtists = self.spotifyArtists
        }
    }
}
