//
//  ViewController.swift
//  tipster
//
//  Created by Sarn Wattanasri on 12/4/15.
//  Copyright © 2015 Sarn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegmentedControl: UISegmentedControl!
    
    var tipPercentages: [Float] = [0.18, 0.2, 0.22]
    
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        //perform calculation and update UIs
        calculateTipAndTotal()
        
        //save billAmount to NSUserDefaults via PersistenceManager
        let billAmount = (billTextField.text! as NSString).floatValue
        if var userSettingsModel = PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel") {
            userSettingsModel.amount = billAmount
            let result = PersistenceManager.saveToNSUserDefaults(userSettingsModel)
            print("saved successfully: \(result)")
        }
    }
    
    //helper: calculate tip and total
    func calculateTipAndTotal() {
        let tipPercent = tipPercentages[tipSegmentedControl.selectedSegmentIndex]
        let billAmount = (billTextField.text! as NSString).floatValue
        
        let tip = billAmount * tipPercent
        let total = billAmount + tip
        tipLabel.text = formatCurrency(tip)
        totalLabel.text = formatCurrency(total)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //if model is ready, use it to configure tip percentages: [happy, happier, happiest]
        if let userSettingsModel = PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel") {
            tipPercentages[0] = round(userSettingsModel.happyPercentage * 100) / 100
            tipPercentages[1] = round(userSettingsModel.happierPercentage * 100) / 100
            tipPercentages[2] = round(userSettingsModel.happiestPercentage * 100) / 100
            
            if userSettingsModel.amount > 0 {
                billTextField.text = "\(userSettingsModel.amount)"
            }
            
            //change tip labels
            for position in 0...tipPercentages.count-1 {
                setSegmentedControlTitle(position, tipPercentages: tipPercentages)
                print("tip percentage value: \(tipPercentages[position])")
            }
        }
        
        //perform calcuation and update UIs
        calculateTipAndTotal()
    }
    
    //helper: set title of SegmentedControl by index
    func setSegmentedControlTitle(position: Int, tipPercentages: [Float]) {
        tipSegmentedControl.setTitle("\( round(tipPercentages[position]*100) )%", forSegmentAtIndex: position)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //format the currency amount
    func formatCurrency(amount: Float) -> String {
        return String(format: "$%.2f", amount)
    }


    @IBAction func onTapped(sender: AnyObject) {
        //dismiss the keyboard
        view.endEditing(true)
    }
}

