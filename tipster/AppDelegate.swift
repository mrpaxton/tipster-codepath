//
//  AppDelegate.swift
//  tipster
//
//  Created by Sarn Wattanasri on 12/4/15.
//  Copyright © 2015 Sarn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // set the billSplitEnabled value in the NSUserDefaults to false
        PersistenceManager.saveBoolToNSUserDefaults("billSplitEnabled", value: false)
        
        // initalize tip percentages and bill amount
        if var userSettingsModel = PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel") {
            userSettingsModel.amount = 0.0
            userSettingsModel.happyPercentage = 0.18
            userSettingsModel.happierPercentage = 0.20
            userSettingsModel.happiestPercentage = 0.22
            PersistenceManager.saveToNSUserDefaults(userSettingsModel)
        }
        
        //clear the billAmount state 10 minutes after
        let date = NSDate().dateByAddingTimeInterval(10*60)
        let timer = NSTimer(fireDate: date, interval: 0, target: self, selector: "clearBillAmount", userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //helper: clear billAmount
    func clearBillAmount() {
        if var userSettingsModel = PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel") {
            userSettingsModel.amount = 0.0
            PersistenceManager.saveToNSUserDefaults(userSettingsModel)
        }
    }



}

