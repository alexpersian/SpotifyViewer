//
//  DetailViewController.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/8/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import Foundation
import AVFoundation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistFollowers: UILabel!
    @IBOutlet weak var artistBio: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playArtistSampleButton: UIButton!
    
    var artist: SpotifyArtist!
    var player: AVPlayer!
    
    override func viewDidLoad() {
        styleArtistImage()
        styleArtistButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadArtistInformation()
        loadArtistImage()
        loadArtistBio()
    }
    
    func styleArtistButton() {
        playArtistSampleButton.layer.cornerRadius = playArtistSampleButton.frame.size.height / 2
        playArtistSampleButton.clipsToBounds = true
    }
    
    func styleArtistImage() {
        artistImage.layer.cornerRadius = artistImage.frame.size.width / 2
        artistImage.clipsToBounds = true
    }
    
    func loadArtistInformation() {
        guard artist != nil else { return }
        artistName.text = artist.artistName
        let numFormatter = NSNumberFormatter()
        numFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        guard let followerNumber = numFormatter.stringFromNumber(artist.artistFollowers.numberOfFollowers) else { return }
        artistFollowers.text = artistFollowers.text?.stringByAppendingString("  \(followerNumber)")
    }
    
    func loadArtistImage() {
        guard artist != nil,
            let imageURL = artist.artistImageURLs?.first?.artistImageURL else { return }
        SARequestManager.sharedManager.getArtistImageFromURL(imageURL) { result in
            switch result {
            case .Success(let image):
                self.artistImage.image = image
                self.backgroundImageView.image = image
            case .Failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func loadArtistBio() {
        guard artist != nil else { return }
        LFRequestManager.sharedManager.getArtistBioWithQuery(artist.artistName) { (result) in
            switch result {
            case .Success(let lfArtistBio):
                self.artistBio.setTextWithExistingAttributes(lfArtistBio.bioSummary)
            case .Failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchArtistTopTrack() {
        guard artist != nil else { return }
        SARequestManager.sharedManager.getArtistTopTrackFromID(artist.artistID) { (result) in
            switch result {
            case .Success(let track):
                guard let trackURL = NSURL(string: track.previewURL) else { return }
                let playerItem = AVPlayerItem(URL: trackURL)
                self.player = AVPlayer(playerItem: playerItem)
                self.player.play()
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func playArtistSample(sender: UIButton) {
        print("playing artist")
        fetchArtistTopTrack()
    }
}
