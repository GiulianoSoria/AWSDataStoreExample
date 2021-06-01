//
//  AppDelegate.swift
//  Offline-Storage
//
//  Created by Kyle Lee on 6/30/20.
//

import Amplify
import AWSDataStorePlugin
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    do {
      try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
      try Amplify.configure()
      print("It worked")
    } catch {
      print(error)
    }    
    
    return true
  }
  
}

