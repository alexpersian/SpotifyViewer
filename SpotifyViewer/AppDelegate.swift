//
//  AppDelegate.swift
//  SpotifyViewer
//
//  Created by Alexander Persian on 6/6/16.
//  Copyright © 2016 Alexander Persian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var session: SPTSession?
    var player: SPTAudioStreamingController?
    
    let kClientId = "5d6321d41dc9487189b7f0b28a585190"
    let kRedirectURL = "intrepid-spotify-viewer-login://callback"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        SPTAuth.defaultInstance().clientID = kClientId
//        SPTAuth.defaultInstance().redirectURL = NSURL(string: kRedirectURL)
//        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
//        
//        if SPTAuth.defaultInstance().session == nil {
//            
//        }
//        
//        let loginURL = SPTAuth.defaultInstance().loginURL
//        UIApplication.sharedApplication().openURL(loginURL)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if (SPTAuth.defaultInstance().canHandleURL(url)) {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error, session) in
                if (error != nil) {
                    print("*** Auth error: \(error)")
                    return
                }
            })
        }
        return false
    }
    
    func playUsingSession(session: SPTSession) {
        if (player == nil) {
            player = SPTAudioStreamingController(clientId: SPTAuth.defaultInstance().clientID)
        }
        
        player!.loginWithSession(session, callback: { (error) in
            if (error != nil) {
                print("*** Logging in resulted in error: \(error)")
                return
            }
            
            print(session.isValid())
            let trackURI = NSURL(string: "spotify:track:5Ll49agi6M3BQdSSGRQ8Hl")
            
            self.player!.playURI(trackURI, callback: { (error) in
                if (error != nil) {
                    print("*** Starting playback got error: \(error)")
                    return
                }
            })
        })
    }
}

