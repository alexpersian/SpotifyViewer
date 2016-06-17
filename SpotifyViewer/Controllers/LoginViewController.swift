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
    
    @IBAction func loginToSpotify(sender: UIButton) {
        
        self.performSegueWithIdentifier("LoginToSearchSegue", sender: sender)
    }
}
