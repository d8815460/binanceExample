//
//  AppDelegate.swift
//  example
//
//  Created by 陳駿逸 on 2020/2/10.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISceneDelegate {

    var window: UIWindow?
    private var reachability = Reachability()!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Reachability
        do {
            if reachability.isReachable {
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(AppDelegate.reachabilityChanged(_:)),
                                                       name: ReachabilityChangedNotification,
                                                       object: self.reachability)
                try reachability.startNotifier()
            } else {
                print("Unable to create Reachability")
            }
        } catch {
            print("Unable to create Reachability")
        }
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: KSDidEnterBackgroundNotificationKey), object: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: KSWillEnterForegroundNotificationKey), object: nil)
    }
    
    
    @objc func reachabilityChanged(_ notification: Notification) {
        let networkReachability = notification.object as! Reachability;
        let isReachable = networkReachability.isReachable
        
        if (isReachable) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: KSReachabilityConnectedNotificationKey), object: nil)
            print("REACHABILITY -> Connected to the internet")
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: KSReachabilityDisConnectedNotificationKey), object: nil)
            print("REACHABILITY -> NOT Connected to the internet")
        }
    }
}

