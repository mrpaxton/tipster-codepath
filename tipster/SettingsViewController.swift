//
//  SettingsViewController.swift
//  tipster
//
//  Created by Sarn Wattanasri on 12/5/15.
//  Copyright © 2015 Sarn. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

   
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var happierLabel: UILabel!
    @IBOutlet weak var happiestLabel: UILabel!
    @IBOutlet weak var happySlider: UISlider!
    @IBOutlet weak var happierSlider: UISlider!
    @IBOutlet weak var happiestSlider: UISlider!
    @IBOutlet weak var billSplitSwitch: UISwitch!
    var billSplitEnabled = false
    
    
    var userSettingsModel: UserSettingsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userSettingsModel == nil {
            userSettingsModel = UserSettingsModel(amount: 0.0, happyPercentage: 0.0,
                happierPercentage: 0.0, happiestPercentage: 0.0)
        }
        
        if let model = PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel") {
            userSettingsModel = model
            happyLabel.text = formatPercentage(userSettingsModel.happyPercentage)
            happierLabel.text = formatPercentage(userSettingsModel.happierPercentage)
            happiestLabel.text = formatPercentage(userSettingsModel.happiestPercentage)
            
            happySlider.setValue(userSettingsModel.happyPercentage, animated: true)
            happierSlider.setValue(userSettingsModel.happierPercentage, animated: true)
            happiestSlider.setValue(userSettingsModel.happiestPercentage, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBillSplitSwitchValueChanged(sender: UISwitch) {
        if sender.on {
            billSplitEnabled = true
        } else {
            billSplitEnabled = false
        }
    }
    
    @IBAction func onHappySliderChanged(sender: UISlider) {
        userSettingsModel.happyPercentage = sender.value
        happyLabel.text = formatPercentage(roundFloatToTwoDigits(sender.value))
    }

    @IBAction func onHappierSliderChanged(sender: AnyObject) {
        userSettingsModel.happierPercentage = sender.value
        happierLabel.text = formatPercentage(roundFloatToTwoDigits(sender.value))
    }
    
    @IBAction func onHappiestSliderChanged(sender: AnyObject) {
        userSettingsModel.happiestPercentage = sender.value
        happiestLabel.text = formatPercentage(roundFloatToTwoDigits(sender.value))
    }
    
    //helper function
    func roundFloatToTwoDigits(value: Float) -> Float {
        return roundf(value*100) / 100
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        PersistenceManager.saveToNSUserDefaults(userSettingsModel)
        PersistenceManager.saveBoolToNSUserDefaults("billSplitEnabled",
            value: billSplitEnabled)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        billSplitEnabled =
            PersistenceManager.retrieveBoolFromNSUserDefaults("billSplitEnabled")
        //set the value of the bill split switch
        billSplitSwitch.on = billSplitEnabled
        
    }
    
    //heler function: format the percentage
    func formatPercentage(percentage: Float) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        return formatter.stringFromNumber(percentage as NSNumber)!
    }

}
