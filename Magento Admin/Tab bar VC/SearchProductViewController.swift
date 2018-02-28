//
//  SearchProductViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 09/10/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit


protocol SearchProdFilterDelegate : class {
    func sendDataOfUser(name:String)
}

class SearchProductViewController: UIViewController ,UITextFieldDelegate {
    
    
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textF1: UITextField!
    
    var nameVal = String()
    
    var activeTextField : UITextField!
    
    weak var delegate: SearchProdFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        textF1.text = nameVal
        searchButton.backgroundColor = ObjRef.sharedInstance.magentoGreen
        searchButton.layer.cornerRadius = searchButton.frame.size.height*0.5
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        if (textF1.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            textF1.text = ""
        }
        
        self.delegate?.sendDataOfUser(name: textF1.text!)
        
        _ = self.navigationController?.popViewController(animated: true)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
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
