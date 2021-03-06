//
//  ViewController.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/6/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var spotifySearchBar: UITextField!
    @IBOutlet weak var spotifyResultsView: UITableView!
    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    
    var spotifyArtists = [SpotifyArtist]()
    let transitionManager = TransitionManager()
    var selectedArtistIndex = 0
    
    override func viewWillAppear(animated: Bool) {
        checkForRecentSearches()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SearchToDetailSegue") {
            guard spotifyArtists.count > 0,
                let detailVC = segue.destinationViewController as? DetailViewController else {
                    print("Artist array is empty")
                    return
            }
            detailVC.artist = spotifyArtists[selectedArtistIndex]
            detailVC.transitioningDelegate = self.transitionManager
        }
    }
    
    func checkForRecentSearches() {
        
        let realmResults = RealmManager.sharedManager.getArtists()
        for artist in realmResults {
            spotifyArtists.append(artist as SpotifyArtist)
        }
    }
    
    @IBAction func returnToArtistSearch(segue: UIStoryboardSegue) { }
    
// MARK: - UITableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotifyArtists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArtistCell", forIndexPath: indexPath)
        
        guard spotifyArtists.count > 0 else { return cell }
        let row = indexPath.row
        cell.textLabel?.text = spotifyArtists[row].artistName
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArtistIndex = indexPath.row
        
        do {
            try RealmManager.sharedManager.save([spotifyArtists[selectedArtistIndex]])
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        performSegueWithIdentifier("SearchToDetailSegue", sender: nil)
    }
    
// MARK: - UITextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchActivityIndicator.hidden = false
        searchActivityIndicator.startAnimating()
        
        guard let searchQuery = textField.text else { print("yall's text field dun broke"); return true }
        spotifyArtists.removeAll()
        
        SARequestManager.sharedManager.getArtistsWithQuery(searchQuery, completion: { result in
            switch result {
            case .Success(let artists):
                self.spotifyArtists = artists
                self.spotifyResultsView.reloadData()
            case .Failure(let error):
                print(error.localizedDescription)
            }
            self.searchActivityIndicator.stopAnimating()
        })
        
        self.spotifySearchBar.endEditing(true)
        
        return true
    }
}

