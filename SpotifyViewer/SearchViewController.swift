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
    
    var spotifySession: SPTSession!
    var spotifyArtists: [SpotifyArtist]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard spotifyArtists != nil else { print("shit's all broke as fuck"); return }
        print(spotifyArtists)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SearchToDetail") {
            
        }
    }
    
    @IBAction func returnToArtistSearch(segue: UIStoryboardSegue) {
        
    }

    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard spotifyArtists != nil else { return 1 }
        return spotifyArtists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArtistCell", forIndexPath: indexPath)
        
        guard spotifyArtists != nil else { return cell }
        let row = indexPath.row
        cell.textLabel?.text = spotifyArtists[row].artistName
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("this row is dank: \(tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)")
        
        performSegueWithIdentifier("SearchToDetailSegue", sender: nil)
    }
    
    // MARK: - UITextField
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // maybe do active searching?
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print(textField.text)
        
        searchActivityIndicator.hidden = false
        searchActivityIndicator.startAnimating()
        
        guard let searchQuery = textField.text else { print("yall's text field dun broke"); return true }
        if self.spotifyArtists != nil {
            self.spotifyArtists.removeAll()
        }
        SARequestManager.sharedManager.getArtistsWithQuery(searchQuery, success:
        { (artists) in
            self.spotifyArtists = artists
            self.spotifyResultsView.reloadData()
            self.searchActivityIndicator.stopAnimating()
        })
        { (error) in
            print(error)
            self.searchActivityIndicator.stopAnimating()
        }
        
        return true
    }
}

