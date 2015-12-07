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
    
    
    var userSettingsModel: UserSettingsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userSettingsModel == nil {
            userSettingsModel = UserSettingsModel(amount: 0.0, happyPercentage: 0.0,
                happierPercentage: 0.0, happiestPercentage: 0.0)
        }
        
        if let model = PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel") {
            userSettingsModel = model
            happyLabel.text = String(format: "%.2f", userSettingsModel.happyPercentage)
            happierLabel.text = String(format: "%.2f", userSettingsModel.happierPercentage)
            happiestLabel.text = String(format: "%.2f", userSettingsModel.happiestPercentage)
            
            happySlider.setValue(userSettingsModel.happyPercentage, animated: true)
            happierSlider.setValue(userSettingsModel.happierPercentage, animated: true)
            happiestSlider.setValue(userSettingsModel.happiestPercentage, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHappySliderChanged(sender: UISlider) {
        userSettingsModel.happyPercentage = sender.value
        happyLabel.text = String(format: "%.2f", roundf(sender.value*100)/100)
    }

    @IBAction func onHappierSliderChanged(sender: AnyObject) {
        userSettingsModel.happierPercentage = sender.value
        happierLabel.text = String(format: "%.2f", roundf(sender.value*100)/100)
    }
    
    @IBAction func onHappiestSliderChanged(sender: AnyObject) {
        userSettingsModel.happiestPercentage = sender.value
        happiestLabel.text = String(format: "%.2f", roundf(sender.value*100)/100)
    }
    
    //persist data: when? view will disappear?
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let saveResult = PersistenceManager.saveToNSUserDefaults(userSettingsModel)
        print("save result: \(saveResult)")
//        print(PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel"))
//        print(userSettingsModel.happyPercentage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("abcdef")
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
