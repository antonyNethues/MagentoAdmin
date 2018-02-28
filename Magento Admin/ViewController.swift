//
//  ViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var remeberMeSwitch: UISwitch!
    @IBOutlet var password: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    var websiteData = NSDictionary()
    
    @IBOutlet var remMeLab: UILabel!
    var activeTextField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerForKeyboardNotifications()
        let userD = UserDefaults.standard
        if let userN = userD.value(forKey: "username") as? String {
            userName.text = userN
            password.text = userD.value(forKey: "password") as? String
            remeberMeSwitch.setOn(true, animated: true)
        }
        else {
            remeberMeSwitch.setOn(false, animated: true)
        }

        userName.delegate = self
        password.delegate = self
        
        remMeLab.isHidden = false
        
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

    @IBAction func remeberMeSwitchChanged(_ sender: Any) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if (userName.text?.characters.count)! > 0 && (password.text?.characters.count)! > 0 {
            
            let userD = UserDefaults.standard
            if remeberMeSwitch.isOn == true {
                userD.set(userName.text!, forKey: "username")
                userD.set(password.text!, forKey: "password")
            }
            else {
                userD.removeObject(forKey: "username")
                userD.removeObject(forKey: "password")
            }

            _ = [ "username":userName.text!,
                              "password":password.text!,
                              "device_token":UIDevice.current.identifierForVendor!.uuidString,
                              "device_type":"ios"
            ] as NSDictionary
            
            let paramStr = "username=\(userName.text!)&password=\(password.text!)&device_token=\(APIManager.sharedInstance.websiteToken)&device_type=ios&token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
           APIManager.sharedInstance.postRequestWithId(appendParam: "user/login/", bodyData: paramStr, presentingView: self.view, onSuccess: { (json) in
            
            if json.count > 0 {
                let success = json["success"] as! Bool
                    if success == true  {
                        if let webId = json["id"] as? String {

                            APIManager.sharedInstance.websiteId = webId
                            UserDefaults.standard.set(webId, forKey: "websiteId")

                        }
                        if let name = json["name"] as? String {
                            UserDefaults.standard.set(name, forKey: "name")
                            ObjRef.sharedInstance.userName = name
                        }
                        
                        if let userEmail = json["userEmail"] as? String {
                            UserDefaults.standard.set(userEmail, forKey: "userEmail")
                            ObjRef.sharedInstance.userEmail = userEmail
                        }
                        UserDefaults.standard.set(APIManager.sharedInstance.websiteToken, forKey: "websiteToken")

                        DispatchQueue.main.async(execute: { () -> Void in
                            //HomeVC
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? MagentoTabBarController
//                            
                            //                            self.present(vc!, animated: true, completion: nil)
                            UserDefaults.standard.set(1, forKey: "alreadyLogin")
                            UserDefaults.standard.synchronize()
                            MagentoDatabase.sharedInstance.createDB()

                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
                            
                            self.present(vc!, animated: true, completion: nil)
                        })
                        
                    }
                    else {
                        DispatchQueue.main.async(execute: { () -> Void in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let message = json["message"]
                            let alert = UIAlertController(title: "Error", message: (message as! String), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        })
                        
                }
            }
            
           }, onFailure: { error in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            
           })
        }
        else {
            DispatchQueue.main.async(execute: { () -> Void in
                
                let alert = UIAlertController(title: "", message: "Please Enter Correct Username And Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }

    }

}

