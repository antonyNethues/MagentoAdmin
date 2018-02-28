//
//  ChangePasswordViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 25/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textF1: UITextField!
    @IBOutlet var textF2: UITextField!
    @IBOutlet var textF3: UITextField!
    var activeTextField : UITextField!

    @IBOutlet var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerForKeyboardNotifications()
        submitButton.layer.cornerRadius = submitButton.frame.size.height*0.5
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        if (activeTextField ) != nil
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

    @IBAction func menuTapped(_ sender: Any) {
        let vc = self.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height*0.5
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
        
        //self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        ObjRef.sharedInstance.setupNavigationBar(vc: self)

        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
    }
    func navigationBtnLeftTapped() {
        let vcHome = self.parent?.parent as! HomeViewController
        vcHome.tabBar(vcHome.customTabBar, didSelect: vcHome.customTabBar.selectedItem!)
        //self.navigationItem.setLeftBarButtonItems(nil, animated: false)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.textF1.text = ""
        self.textF2.text = ""
        self.textF3.text = ""
        
        self.navigationBtnLeftTapped()
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        if (textF1.text?.characters.count)! > 0 && (textF2.text?.characters.count)! > 0 && (textF3.text?.characters.count)! > 0 && (textF1.text?.characters.count)! > 0 {
            
            if textF2.text == textF3.text {
                APIManager.sharedInstance.postRequestWithId(appendParam: "user/changepassword/", bodyData: "id=\(APIManager.sharedInstance.websiteId)&old_password=\(textF1.text!)&new_password=\(textF2.text!)&confirm_password=\(textF3.text!)&token=ABCDEFGHIJKLMNOPQRSTUVWXYZ", presentingView: self.view, onSuccess: { (response) in
                    
                    if let responseData = response as? NSDictionary {
                        if let active = responseData.object(forKey: "active") as? Int {
                            if active == 0 {
                                if let message = responseData.object(forKey: "message") as? String {
                                    ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                                }
                            }
                            else {
                                
                            }
                        }
                        else {
                            
                            if let success = response["success"] as? String {
                                if success == "true" {
                                    let alert = UIAlertController(title: "", message: response["message"] as? String, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (alert) in
                                        self.backTapped(UIButton.self)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    
                                }
                                else {
                                    let alert = UIAlertController(title: "", message: response["message"] as? String, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (alert) in
                                        self.backTapped(UIButton.self)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                
                            }
                        }
                    }

                }, onFailure: { (error) in
                    //UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
                })

            }
            else {
                let alert = UIAlertController(title: "Error", message: "Password is not same", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
 
            }
        }
        
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
