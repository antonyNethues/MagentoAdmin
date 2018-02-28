//
//  ScanQRCodeViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 10/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit



class ScanQRCodeViewController: UIViewController,AMScanQRCodeVCDelegate,UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
        
    @IBOutlet var QRValueField: UITextField!
    var activeTextField : UITextField!
    var uniqueToken = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AMScanQRCodeVC {
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        QRValueField.delegate = self
      // Do any additional setup after loading the view.
        registerForKeyboardNotifications()
        //self.uniqueToken = self.randomString(length: 8)
        self.uniqueToken = "abcdefghijklmnopqrstu"
    }
    @IBAction func showModuleDesc(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModuleDescViewController") as? ModuleDescViewController
        //vc?.delegateNew = self
        self.navigationController?.navigationBar.isHidden = true
        
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    func registerForKeyboardNotifications()
    {
            //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanTapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AMScanQRCodeVC") as? AMScanQRCodeVC
        vc?.delegateNew = self
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        
        
        
        if (QRValueField.text?.characters.count)! > 0 {
            
            APIManager.sharedInstance.postRequestWithId(appendParam: "scan", bodyData: "license=\(QRValueField.text!)&device_token=\(self.uniqueToken)&op=getUrl&token=ABCDEFGHIJKLMNOPQRSTUVWXYZ", presentingView: self.view, onSuccess: { (response) in
                
                if response is NSDictionary {
                    if let active = response["active"] as? Int {
                        if active == 1 {
                            APIManager.sharedInstance.websiteToken = self.uniqueToken
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? ViewController
                            vc?.websiteData = response as! NSDictionary
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                self.present(vc!, animated: true, completion: nil)
                            })
                        }
                        else {
                            DispatchQueue.main.async(execute: { () -> Void in
                                MBProgressHUD.hide(for: self.view, animated: true)
                                if let message = response["message"] as? String {
                                    
                                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }

                            })
                            
                        }
                    }
                }
                
            }, onFailure: { (error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            })
            
            
        }
        else {
            DispatchQueue.main.async(execute: { () -> Void in
                
                let alert = UIAlertController(title: "", message: "Please Enter Key Before Submitting", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }

    func setQRValue(val: String) {
        QRValueField.text = val
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = QRValueField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = UITextField()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        QRValueField.resignFirstResponder()
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
