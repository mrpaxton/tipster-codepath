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
    
    let tipPercentages = [0.18, 0.2, 0.22]
    
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        let tipPercent = tipPercentages[tipSegmentedControl.selectedSegmentIndex]
        let billAmount = (billTextField.text! as NSString).doubleValue
        let tip = billAmount * tipPercent
        let total = billAmount + tip
        tipLabel.text = formatCurrency(tip)
        totalLabel.text = formatCurrency(total)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //calculate the total amount given a bill amount and tip percentage
    
    
    //format the currency amount
    func formatCurrency(amount: Double) -> String {
        return String(format: "$%.2f", amount)
    }


    @IBAction func onTapped(sender: AnyObject) {
        //dismiss the keyboard
        view.endEditing(true)
    }
}

