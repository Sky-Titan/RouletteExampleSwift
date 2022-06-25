//
//  AppDelegate.swift
//  RouletteExample
//
//  Created by 박준현 on 2022/06/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let root = UINavigationController(rootViewController: ViewController())
        root.isNavigationBarHidden = true
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        return true
    }


}

