//
//  AppDelegate.swift
//  TimePad
//
//  Created by yxgg on 27/05/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    if #available(iOS 13.0, *) {
      // handled in scene delegate
    } else {
      let viewController = MainViewController()
      let window = UIWindow()
      window.rootViewController = viewController
      window.makeKeyAndVisible()
      self.window = window
    }
    IQKeyboardManager.shared.enable = true
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

