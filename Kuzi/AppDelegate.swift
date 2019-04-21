//
//  AppDelegate.swift
//  Kuzi
//
//  Created by John Bogil on 4/7/19.
//  Copyright © 2019 John Bogil. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


        window = UIWindow()
        window?.backgroundColor = .white
        let navVC = UINavigationController.init(rootViewController: ViewController())
        window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()

        return true
    }

}

