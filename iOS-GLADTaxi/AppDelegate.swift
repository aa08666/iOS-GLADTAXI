//
//  AppDelegate.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 on 2019/4/16.
//  Copyright © 2019 柏呈. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit


let googleApikey = "AIzaSyA4v1pdhTR43JbRgRh21behSk1MZwlH1uU"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(googleApikey)
        return true
    }
    
 
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handle
    }
  

}

