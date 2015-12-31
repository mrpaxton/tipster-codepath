//
//  ViewController.swift
//  tipster
//
//  Created by Sarn Wattanasri on 12/4/15.
//  Copyright © 2015 Sarn. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    @IBOutlet weak var billSplitView: UIView!
    @IBOutlet weak var billAmountPreAnimView: UIView!
    @IBOutlet weak var billAmountPostAnimView: UIView!
    @IBOutlet weak var superTipperNavItem: UINavigationItem!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numPeoplePicker: UIPickerView!
    var tipPercentages: [Float] = [0.18, 0.2, 0.22]
    
    //properties for bill splitting
    @IBOutlet weak var individualAmountLabel: UILabel!
    var billSplitEnabled = false
    var totalAmount = Float(0.0)
    let numOfPeopleList = [1,2,3,4,5,6,7,8,9,10]
    var numOfPeople = 1
    
    //properties for takeing and send the photo over
    var imagePicker: UIImagePickerController!
    var photoImageView: UIImageView!
    var billImage: UIImage!
    
    //round knob holder view
    @IBOutlet weak var roundKnobHolderView: UIView!
    
    var tipPresetMode = true
    var tipValueFromKnob:Float = 0.0
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        calculateTipAndTotal()
        saveBillAmountToStorage()
    }
    
    @IBAction func onTapped(sender: AnyObject) {
        //dismiss the keyboard
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldFirstResponder()
        beautifyNavBar()
        animateBillAmountTextField()
        addRoundKnob()
        
        //a hack: .TouchUpInside event does not work; .AllEvents works. So, use it for now
        tipSegmentedControl.addTarget(self, action: "onAllEvents:", forControlEvents: .AllEvents)
    }
    
    //callback: action when there is an event fired from the tipSegmentedControl
    func onAllEvents(sender: AnyObject?) {
        tipPresetMode = true
        calculateTipAndTotal()
    }
    
    func addRoundKnob() {
        //use a custom knob (from Knob.swift)
        let knobFrame = CGRect(x: 5, y:10,
            width: roundKnobHolderView.frame.size.width - 10,
            height: roundKnobHolderView.frame.size.height )
        let myKnob = Knob( frame: knobFrame )
        myKnob.lineWidth = 7.5
        myKnob.pointerLength = 15.0
        myKnob.value = 0.25
        myKnob.maximumValue = 0.65
        myKnob.minimumValue = 0.10
        myKnob.addTarget(self, action: "knobValueChanged:", forControlEvents: .ValueChanged)
        roundKnobHolderView.addSubview( myKnob )
    }
    
    func knobValueChanged(knob: Knob) {
        //update tip amount
        //update total
        //update individual amount
        tipPresetMode = false
        tipValueFromKnob = roundf( knob.value * 100 )  / 100
        calculateTipAndTotal()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateDataFromStorage()
        calculateTipAndTotal()
        checkBillSplitView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //helper function: check whether the bill split feature is enabled; then, show the sub view
    func checkBillSplitView() {
        billSplitView.hidden = true
        //billSplitEnabled initializes billSplitView
        billSplitEnabled = PersistenceManager.retrieveBoolFromNSUserDefaults("billSplitEnabled")
        if billSplitEnabled {
            billSplitView.hidden = false
        }
    }
    
    //helper function: set title of SegmentedControl by index
    func setSegmentedControlTitle(position: Int, tipPercentages: [Float]) {
        tipSegmentedControl.setTitle("\( round(tipPercentages[position]*100) )%",
            forSegmentAtIndex: position)
    }
    
    //helper function:  perform calcuation for tip and total and update labels
    func calculateTipAndTotal() {
        var tipPercent:Float!
        if tipPresetMode {
            tipPercent = tipPercentages[tipSegmentedControl.selectedSegmentIndex]
        } else {
            tipPercent = tipValueFromKnob
        }
        
        let billAmount = (billTextField.text! as NSString).floatValue
        
        let tip = billAmount * tipPercent
        let total = billAmount + tip
        self.totalAmount = total
        tipLabel.text = formatCurrency(tip)
        totalLabel.text = formatCurrency(total)
        
        individualAmountLabel.text = formatCurrency((totalAmount / Float(numOfPeople)))
        individualAmountLabel.hidden = false
    }
    
    //helper function: format the currency amount
    func formatCurrency(amount: Float) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        return formatter.stringFromNumber(amount as NSNumber)!
    }
    
    //helper function:
    func setTextFieldFirstResponder() {
        //make the billAmount TextField become the first responder
        billTextField.becomeFirstResponder()
    }
    
    //helper function:
    func beautifyNavBar() {
        // Set navigation bar background color
        self.navigationController!.navigationBar.barTintColor =
            UIColor(red: 0.098, green: 0.161, blue: 0.275, alpha: 1.00)
        
        //Set navigation bar title text color
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.yellowColor()]
    }
    
    //helper function:
    func animateBillAmountTextField() {
        //animate billAmountEnterView from alpha 0 to alpha 1
        billAmountPreAnimView.alpha = 1
        billAmountPostAnimView.alpha = 0
        UIView.animateWithDuration(1.5, animations: {
            self.billAmountPreAnimView.alpha = 0
            self.billAmountPostAnimView.alpha = 1
        })
    }
    
    //helper function:
    func updateDataFromStorage() {
        //use the model to configure tip percentages: [happy, happier, happiest]
        if let userSettingsModel = PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel") {
            tipPercentages[0] = round(userSettingsModel.happyPercentage * 100) / 100
            tipPercentages[1] = round(userSettingsModel.happierPercentage * 100) / 100
            tipPercentages[2] = round(userSettingsModel.happiestPercentage * 100) / 100
            
            if userSettingsModel.amount > 0 {
                billTextField.text = "\(userSettingsModel.amount)"
            } else {
                billTextField.text = ""
            }
            
            //change tip labels
            for position in 0...tipPercentages.count-1 {
                setSegmentedControlTitle(position, tipPercentages: tipPercentages)
                print("tip percentage value: \(tipPercentages[position])")
            }
        }
    }
    
    //helper function:
    func saveBillAmountToStorage() {
        //save billAmount to NSUserDefaults via PersistenceManager
        let billAmount = (billTextField.text! as NSString).floatValue
        if var userSettingsModel = PersistenceManager.retrieveObjectFromNSUserDefaults("userSettingsModel") {
            userSettingsModel.amount = billAmount
            PersistenceManager.saveToNSUserDefaults(userSettingsModel)
        }
    }

}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numOfPeopleList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String( numOfPeopleList[row] )
    }

    
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numOfPeople = numOfPeopleList[row]
        individualAmountLabel.text = formatCurrency((totalAmount / Float(numOfPeople)))
        individualAmountLabel.hidden = false
    }
}

//Use the device camera to take the bill photo
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func onPhotoTaken(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        //show the device camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let photoViewController = segue.destinationViewController as? PhotoViewController {
            photoViewController.billImage = self.billImage
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        billImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //segue to the PhotoViewController sending the photoImageView
        self.performSegueWithIdentifier("showPhotoView", sender: self)
    }
}

