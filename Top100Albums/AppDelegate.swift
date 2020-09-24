//
//  AppDelegate.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   var window: UIWindow?
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      window =  UIWindow(frame: UIScreen.main.bounds)
      // TODO:
      window?.rootViewController = UIViewController()
      window?.makeKeyAndVisible()
      
      // TEST:
      RssAPI.topAlbums { response in
         print(try? response.decode(as: Feed.Response.self))
      }
      
      return true
   }
}
