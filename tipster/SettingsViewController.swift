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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHappySliderChanged(sender: UISlider) {
        happyLabel.text = String(format: "%.f", roundf(sender.value*100))
    }

    @IBAction func onHappierSliderChanged(sender: AnyObject) {
        happierLabel.text = String(format: "%.f", roundf(sender.value*100))
    }
    
    @IBAction func onHappiestSliderChanged(sender: AnyObject) {
        happiestLabel.text = String(format: "%.f", roundf(sender.value*100))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
