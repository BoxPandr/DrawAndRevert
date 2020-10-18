//
//  AppDelegate.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/16.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//
 
import UIKit

import StoreKit


// 个推。别名， cid 绑定为 user id

// 后端，统一用 user ID 处理


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

     
        if window == nil{
            window = UIWindow(frame: UI.layout)
        }
        window?.rootViewController = PlayerViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
 


}



