
//
//  AppDelegate.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appIsInBackground = Bool()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //237 101 26
        
        //UINavigationBar.appearance().backgroundColor = UIColor(red: 237.0/255.0, green: 101.0/255.0, blue: 26.0/255, alpha: 1.0)
        //UserDefaults.standard.set(1, forKey: "alreadyLogin")
        //UserDefaults.standard.synchronize()

        MagentoDatabase.sharedInstance.createDB()
        

        if let loginVal = UserDefaults.standard.value(forKey: "alreadyLogin") as? Int
        {
            if loginVal == 1 {
                APIManager.sharedInstance.websiteToken = UserDefaults.standard.value(forKey: "websiteToken") as! String
                APIManager.sharedInstance.websiteId = UserDefaults.standard.value(forKey: "websiteId") as! String
                if loginVal == 1 {
                    
                    if let name = UserDefaults.standard.value(forKey: "name") as? String {
                        ObjRef.sharedInstance.userName = name
                    }
                    
                    if let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String {
                        ObjRef.sharedInstance.userEmail = userEmail
                    }
                    
                    
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                    
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                }
            }
        }
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = ObjRef.sharedInstance.magentoOrange
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:ObjRef.sharedInstance.magentoOrange]
        
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        return true
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        appIsInBackground = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

