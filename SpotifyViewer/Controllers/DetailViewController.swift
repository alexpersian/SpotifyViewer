//
//  DetailViewController.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/8/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistBio: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playArtistSampleButton: UIButton!
    
    var artist: SpotifyArtist!
    
    override func viewDidLoad() {
        styleArtistImage()
        styleArtistButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func styleArtistButton() {
        playArtistSampleButton.layer.cornerRadius = playArtistSampleButton.frame.size.height / 2
        playArtistSampleButton.clipsToBounds = true
    }
    
    func styleArtistImage() {
        artistImage.layer.cornerRadius = artistImage.frame.size.width / 2
        artistImage.clipsToBounds = true
    }
    
    @IBAction func playArtistSample(sender: UIButton) {
        print("playing artist")
    }
}
