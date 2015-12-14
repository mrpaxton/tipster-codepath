//
//  PersistenceManager.swift
//  tipster
//
//  Created by Sarn Wattanasri on 12/6/15.
//  Copyright © 2015 Sarn. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    static func saveToNSUserDefaults(obj: UserSettingsModel) -> Bool {
        //Convert Model object to dict; then, save to NSUserDefaults
        let modelDict: NSDictionary = ["amount": obj.amount, "happyPercentage": obj.happyPercentage, "happierPercentage": obj.happierPercentage,
            "happiestPercentage": obj.happiestPercentage]
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(modelDict, forKey: "userSettingsModel")
        return defaults.synchronize()
    }
    
    static func retrieveObjectFromNSUserDefaults(key: String) -> UserSettingsModel? {
        if let model = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSDictionary {
            //construct the UserSettingsModel object and return the value
            var userSettingsModel = UserSettingsModel()
            userSettingsModel.amount = model["amount"]?.floatValue
            userSettingsModel.happyPercentage = model["happyPercentage"]?.floatValue
            userSettingsModel.happierPercentage = model["happierPercentage"]?.floatValue
            userSettingsModel.happiestPercentage = model["happiestPercentage"]?.floatValue
            return userSettingsModel
        }
        return nil
    }
    
    static func saveBoolToNSUserDefaults(key: String, value: Bool) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(value, forKey: key)
        return defaults.synchronize()
    }
    
    static func retrieveBoolFromNSUserDefaults(key: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
}
