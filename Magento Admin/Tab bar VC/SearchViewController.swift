//
//  SearchViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 10/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

protocol SearchOrderFilterDelegate : class {
    func sendDataOfOrder(name:String,id:Int,email:String,fromDate:String,toDate:String)
}

class SearchViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var searchButton: UIButton!
    @IBOutlet var textF1: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textF2: UITextField!
    @IBOutlet var textF3: UITextField!
    @IBOutlet var textF4: UITextField!
    @IBOutlet var textF5: UITextField!
    
    
    var filterValName = String()
    var filterValId = Int()
    var filterValStartTime = String()
    var filterValEndTime = String()
    var filterValEmail = String()

    weak var delegate : SearchOrderFilterDelegate?
    var date: NSDate?
    var dateTo: NSDate?
    var timePicker: UIDatePicker?
    var toTimePicker: UIDatePicker?

    var activeTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        textF1.text = filterValName
        textF3.text = "\(filterValId)"
        textF2.text = filterValEmail
        textF4.text = filterValStartTime
        textF5.text = filterValEndTime

        // Do any additional setup after loading the view.
        registerForKeyboardNotifications()
        
        self.initDatePicker()
        
        if textF4.text != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let convertedStartDate = dateFormatter.date(from: textF4.text!) {
                self.timePicker?.date = convertedStartDate
            }
        }
        if textF5.text != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let convertedStartDate = dateFormatter.date(from: textF5.text!) {
                self.toTimePicker?.date = convertedStartDate
            }
        }
        searchButton.backgroundColor = ObjRef.sharedInstance.magentoGreen
        searchButton.layer.cornerRadius = searchButton.frame.size.height*0.5
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func initDatePicker() {
        if self.timePicker == nil {
            self.timePicker = UIDatePicker()
            self.timePicker!.datePickerMode = UIDatePickerMode.date
            self.timePicker!.addTarget(self, action: #selector(self.updateDate), for: UIControlEvents.valueChanged)
            //self.timePicker!.minimumDate = Date()
            self.timePicker!.backgroundColor = UIColor.white
            self.textF4.inputView = self.timePicker
            self.textF4.inputAccessoryView = self.createPickerToolBar(pickerTextF: self.textF4)
        }
        if self.toTimePicker == nil {
            self.toTimePicker = UIDatePicker()
            self.toTimePicker!.datePickerMode = UIDatePickerMode.date
            self.toTimePicker!.addTarget(self, action: #selector(self.updateDateForToDate), for: UIControlEvents.valueChanged)
            self.toTimePicker!.minimumDate = Date()
            self.toTimePicker!.backgroundColor = UIColor.white
            self.textF5.inputView = self.toTimePicker
            self.textF5.inputAccessoryView = self.createPickerToolBar(pickerTextF: self.textF5)
        }
    }
    
    func updateDate() {
       // let picker: UIDatePicker = self.textF4.inputView as! UIDatePicker
//        var dateF = DateFormatter()
//        dateF.dateFormat = "dd MMM yyyy"
        //self.date = picker.date as NSDate?
        //        self.delegate?.didIntroduceText(self.actionTextView.text.characters.count != 0 && self.searchableTableView?.getText().characters.count != 0 && self.dateLabel.text!.characters.count != 0)
    }
    func updateDateForToDate() {
        //let picker: UIDatePicker = self.textF5.inputView as! UIDatePicker
                //self.textF5.text = dateF.string(from: picker.date)
        //        self.delegate?.didIntroduceText(self.actionTextView.text.characters.count != 0 && self.searchableTableView?.getText().characters.count != 0 && self.dateLabel.text!.characters.count != 0)
    }
    
    func createPickerToolBar(pickerTextF:UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        var doneButton = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneAction))
        if pickerTextF == textF5 {
            doneButton = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneActionToDate))
        }
        //doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: kOpenSansRegular, size: kHeaderFontSize)!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        doneButton.accessibilityLabel = "DoneToolbar"
        
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelAction))
        if pickerTextF == textF5 {
            cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelActionToDate))
        }
        
        //cancelButton.accessibilityLabel = "DoneToolbar"
        
        var clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.clearAction))
        if pickerTextF == textF5 {
            clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.clearActionToDate))
        }
        
        //clearButton.accessibilityLabel = "DoneToolbar"
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.isTranslucent = false
        toolbar.sizeToFit()
        toolbar.setItems([clearButton,cancelButton,spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }
    
    func doneAction() {
        let dateF = DateFormatter()//
        dateF.dateFormat = "yyyy-MM-dd"

        self.date = self.timePicker?.date as NSDate?
        self.textF4.text = dateF.string(from: self.date as! Date)

        self.updateDate()
        self.textF4.resignFirstResponder()
        self.timePicker?.removeFromSuperview()
    }
    func doneActionToDate() {
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        

        self.dateTo = self.toTimePicker?.date as NSDate?
        self.textF5.text = dateF.string(from: self.dateTo as! Date)

        self.updateDateForToDate()
        self.textF5.resignFirstResponder()
        self.toTimePicker?.removeFromSuperview()
    }
    func cancelAction() {
        //self.updateDate()
        let picker: UIDatePicker = self.textF4.inputView as! UIDatePicker
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        if self.date != nil {
            self.textF4.text = dateF.string(from: self.date as! Date)
            picker.date = self.date as! Date
        }
        
        self.textF4.resignFirstResponder()
        self.timePicker?.removeFromSuperview()
    }
    func cancelActionToDate() {
        //self.updateDate()
        let picker: UIDatePicker = self.textF5.inputView as! UIDatePicker
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        if self.dateTo != nil {
            self.textF5.text = dateF.string(from: self.dateTo as! Date)
            picker.date = self.dateTo as! Date
        }
        self.textF5.resignFirstResponder()
        self.toTimePicker?.removeFromSuperview()
    }
    func clearAction() {
        self.textF4.text = ""
        self.textF4.resignFirstResponder()
        self.timePicker?.removeFromSuperview()
    }
    func clearActionToDate() {
        self.textF5.text = ""
        self.textF5.resignFirstResponder()
        self.toTimePicker?.removeFromSuperview()
    }
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: searchButton.frame.origin.y + searchButton.frame.size.height + 50)
        
        let fontSize = 14
        
        self.textF1.font = ObjRef.sharedInstance.updateFont(fontName: (textF1.font?.fontName)!, fontSize: fontSize)
        self.textF2.font = ObjRef.sharedInstance.updateFont(fontName: (textF2.font?.fontName)!, fontSize: fontSize)
        self.textF3.font = ObjRef.sharedInstance.updateFont(fontName: (textF3.font?.fontName)!, fontSize: fontSize)
        self.textF4.font = ObjRef.sharedInstance.updateFont(fontName: (textF4.font?.fontName)!, fontSize: fontSize)
        self.textF5.font = ObjRef.sharedInstance.updateFont(fontName: (textF5.font?.fontName)!, fontSize: fontSize)
        
    }
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if (activeTextField) != nil
        {
            if (!aRect.contains(activeTextField.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
            }
        }
        
        
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
       //var startTimeStamp = Int()
       // var endTimeStamp = Int()
        

        if (textF1.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            textF1.text = ""
        }
        if (textF2.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            textF2.text = ""
        }
        if (textF3.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            textF3.text = "0"
        }
        if (textF4.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            textF4.text = ""
           // startTimeStamp = 0
        }
        else {
            //startTimeStamp = Int(textF4.text!)!
        }
        if (textF5.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            textF5.text = ""
            //endTimeStamp = 0
        }
        else {
            //endTimeStamp = Int(textF5.text!)!
        }
        self.delegate?.sendDataOfOrder(name: textF1.text!, id: Int(textF3.text!)!, email: textF2.text!, fromDate: textF4.text!, toDate: textF5.text!)
        
        _ = self.navigationController?.popViewController(animated: true)
        
        
        
    }
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        _ = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        //self.scrollView.isScrollEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = UITextField()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
