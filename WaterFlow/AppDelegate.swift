//
//  AppDelegate.swift
//  WaterFlow
//
//  Created by zhoucj on 16/9/5.
//  Copyright © 2016年 zhoucj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UINavigationController(rootViewController: WFViewController())
        window?.makeKeyAndVisible()
        return true
    }
}

