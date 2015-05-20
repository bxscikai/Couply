//
//  AppDelegate.swift
//  Couply
//
//  Created by Chenkai Liu on 3/1/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Enable push notifications
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();
        
        // Set API url based on whether we are locally debugging
        if (Constants.Server.LOCAL_DEBUGGING)
        {
            Constants.Server.BaseUrl = Constants.Server.LocalBaseUrl
        }
        else
        {
            getServerBaseIP()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0;
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Push notification handling
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Cache.sharedInstance.deviceToken = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Failed to register for push notification. Error:\(error)");
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Received push notification: \(userInfo)")

        if (userInfo.count > 0) {
            var apsDict = userInfo["aps"] as! NSDictionary
            var emojiId : NSNumber =  (userInfo["emojiId"] as! NSString).integerValue
            var timestamp : NSNumber = (userInfo["timestamp"] as! NSString).doubleValue
            var receivedChat : Chat = Chat(emojiIdReceiving: emojiId, timestamp: timestamp)
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.pushnotification_key, object:receivedChat)
        }
    }
    
    func getServerBaseIP(){
        // Get Server IP
        let url = NSURL(string: Constants.Server.dynamicIPUrl)
        let serverData = NSData(contentsOfURL: url!)
        if (serverData != nil) {
            let newIP = NSString(data: serverData!, encoding: UInt())
            Constants.Server.BaseUrl = newIP as! String
            println("Using fetched IP: \(newIP)")
        }
    }
}

