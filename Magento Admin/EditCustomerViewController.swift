//
//  EditCustomerViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 08/12/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

@objc public protocol EditCustomerDelegate {
    func updateCustomerListing()
}

class EditCustomerViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    open weak var delegate : EditCustomerDelegate!
    
    @IBOutlet var groupTextF: UITextField!
    @IBOutlet var websitetTextF: UITextField!
    @IBOutlet var firstNameInfoLab: UILabel!
    @IBOutlet var lastNameInfoLab: UILabel!
    @IBOutlet var passInfolab: UILabel!
    @IBOutlet var passLab: UILabel!
    @IBOutlet var emailAddLab: UILabel!
    @IBOutlet var LastNameLab: UILabel!
    @IBOutlet var firstNameLab: UILabel!
    @IBOutlet var textFirstName: UITextField!
    
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textEmailAdd: UITextField!
    @IBOutlet var textLastName: UITextField!
    var activeTextField : UITextField!
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var saveButton: UIButton!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    
    var pickerWebsite = UIPickerView()
    var pickerGroup = UIPickerView()

    var groupDataArr = NSArray()
    var websiteDataArr = NSArray()
    var indexSelectedGroup = Int()
    var indexSelectedWebsite = Int()
    
    var editBool = Bool()
    var productData = NSDictionary()
    
    @IBOutlet var labGroup: UILabel!
    @IBOutlet var labAssociate: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        //groupDataArr = ["General","Wholesale","VIP Member","Private Sales Member"]
        groupDataArr = ["Loading..."]
        websiteDataArr = ["Loading..."]
        
        pickerWebsite.delegate = self
        pickerWebsite.dataSource = self
        websitetTextF.inputView = pickerWebsite
        
        pickerGroup.delegate = self
        pickerGroup.dataSource = self
        groupTextF.inputView = pickerGroup
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = ObjRef.sharedInstance.magentoGreen
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker(sender:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelPicker(sender:)))
        
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        websitetTextF.inputAccessoryView = toolBar
        websitetTextF.delegate = self

        
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = ObjRef.sharedInstance.magentoGreen
        toolBar2.sizeToFit()
        
        let doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker(sender:)))
        doneButton2.tag = 2
        
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        spaceButton2.tag = 2
        
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelPicker(sender:)))
        cancelButton2.tag = 2
        
        toolBar2.setItems([cancelButton2,spaceButton2,doneButton2], animated: false)
        toolBar2.isUserInteractionEnabled = true

        groupTextF.inputAccessoryView = toolBar2
        groupTextF.delegate = self

        let fontSizeLab = firstNameInfoLab.font.pointSize
        let fontSizeLabInfo = passInfolab.font.pointSize
        
        firstNameLab.font = ObjRef.sharedInstance.updateFont(fontName: firstNameInfoLab.font.fontName, fontSize: Int(fontSizeLab))
        textFirstName.font = ObjRef.sharedInstance.updateFont(fontName: (textFirstName.font?.fontName)!, fontSize: Int(fontSizeLab))
        emailAddLab.font = ObjRef.sharedInstance.updateFont(fontName: emailAddLab.font.fontName, fontSize: Int(fontSizeLab))
        passLab.font = ObjRef.sharedInstance.updateFont(fontName: passLab.font.fontName, fontSize: Int(fontSizeLab))
        
        LastNameLab.font = ObjRef.sharedInstance.updateFont(fontName: LastNameLab.font.fontName, fontSize: Int(fontSizeLab))
        lastNameInfoLab.font = ObjRef.sharedInstance.updateFont(fontName: lastNameInfoLab.font.fontName, fontSize: Int(fontSizeLabInfo))
        firstNameInfoLab.font = ObjRef.sharedInstance.updateFont(fontName: firstNameInfoLab.font.fontName, fontSize: Int(fontSizeLabInfo))
        passInfolab.font = ObjRef.sharedInstance.updateFont(fontName: passInfolab.font.fontName, fontSize: Int(fontSizeLabInfo))
        
        textEmailAdd.font = ObjRef.sharedInstance.updateFont(fontName: (textEmailAdd.font?.fontName)!, fontSize: Int(fontSizeLab))
        textLastName.font = ObjRef.sharedInstance.updateFont(fontName: (textLastName.font?.fontName)!, fontSize: Int(fontSizeLab))
        textPassword.font = ObjRef.sharedInstance.updateFont(fontName: (textPassword.font?.fontName)!, fontSize: Int(fontSizeLab))
        textFirstName.font = ObjRef.sharedInstance.updateFont(fontName: (textFirstName.font?.fontName)!, fontSize: Int(fontSizeLab))
        
       

        registerForKeyboardNotifications()

        viewHeightConst.constant = saveButton.frame.size.height + saveButton.frame.origin.y + 50
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: viewHeightConst.constant + 50)

        
        self.pickerGroup.selectRow(indexSelectedGroup, inComponent: 0, animated: false)
        pickerGroup.reloadAllComponents()
        
        self.pickerWebsite.selectRow(indexSelectedWebsite, inComponent: 0, animated: false)
        pickerWebsite.reloadAllComponents()
        
        websitetTextF.text = self.websiteDataArr.object(at: indexSelectedWebsite) as? String
        groupTextF.text = self.groupDataArr.object(at: indexSelectedGroup) as? String
        if editBool == true {
            self.setDataForEdit()
        }
        
        labAssociate.font = ObjRef.sharedInstance.updateFont(fontName: (labAssociate.font?.fontName)!, fontSize: Int(fontSizeLab))
        labGroup.font = ObjRef.sharedInstance.updateFont(fontName: (labGroup.font?.fontName)!, fontSize: Int(fontSizeLab))

        self.getWebsiteList()
        self.getGroupList()
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func getGroupList() {
        let localDbUrl = "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&get_customer_group=1"
        
        
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
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
                    
                }
                
                
            }
            else {
                if let responseData = json as? NSArray {
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        self.groupDataArr = responseData
                        self.pickerGroup.selectRow(self.indexSelectedGroup, inComponent: 0, animated: false)
                        
                        self.pickerGroup.reloadAllComponents()
                        if let dictWeb = self.groupDataArr.object(at: self.indexSelectedGroup) as? NSDictionary {
                            self.groupTextF.text = (dictWeb.object(forKey: "customer_group_code") as? String)!
                        }
                        if self.editBool == true {
                            for i in 0  ..< self.groupDataArr.count  {
                                if let id = self.productData.object(forKey: "group_id") as? String {
                                    if let dictWeb = self.groupDataArr.object(at: i) as? NSDictionary {
                                        let dictId = (dictWeb.object(forKey: "customer_group_id") as? String)!
                                        if dictId == id {
                                            
                                            
                                            self.groupTextF.text = (dictWeb.object(forKey: "customer_group_code") as? String)!
                                            self.indexSelectedGroup = i
                                            self.pickerGroup.selectRow(self.indexSelectedGroup, inComponent: 0, animated: false)
                                            
                                            break
                                        }
                                    }
                                    
                                }
                            }
                            
                        }

                        
                    })
                    
                                        /*
                     if self.editBool == true {
                     if let statVal = self.productData.object(forKey: "attribute_set_id") as? String {
                     for i in 0 ..< self.attListArr.count {
                     let attDict = self.attListArr.object(at: i) as? NSDictionary
                     let setId = attDict!["set_id"] as? String
                     if setId == statVal {
                     self.attPicker.selectedIndexCommit = i
                     break
                     }
                     }
                     }
                     }
                     */
                    //                    DispatchQueue.main.async(execute: { () -> Void in
                    //                        self..reloadRows(at: [IndexPath(row: 0, section: 4)], with: UITableViewRowAnimation.none)
                    //                    })
                }
            }
            
        }, onFailure: { (error) in
            self.groupDataArr = ["Error"]

            DispatchQueue.main.async(execute: { () -> Void in
                
                self.pickerGroup.selectRow(self.indexSelectedGroup, inComponent: 0, animated: false)
                
                self.pickerGroup.reloadAllComponents()
            })
            
            //            DispatchQueue.main.async(execute: { () -> Void in
            //
            //                self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: UITableViewRowAnimation.none)
            //            })
            print("Error2: \(error.localizedDescription)")
            
        })
        
    }
    func getWebsiteList() {
        let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&websites=1"
        
        
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        
                        if let data = responseData.object(forKey: "data") as? NSArray {
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                self.websiteDataArr = data
                                self.pickerWebsite.selectRow(self.indexSelectedGroup, inComponent: 0, animated: false)
                                
                                self.pickerWebsite.reloadAllComponents()
                                if let dictWeb = self.websiteDataArr.object(at: self.indexSelectedWebsite) as? NSDictionary {
                                    self.websitetTextF.text = (dictWeb.object(forKey: "website_name") as? String)!
                                }
                                if self.editBool == true {
                                    for i in 0  ..< self.websiteDataArr.count  {
                                        if let id = self.productData.object(forKey: "website_id") as? String {
                                            if let dictWeb = self.websiteDataArr.object(at: i) as? NSDictionary {
                                                let dictId = (dictWeb.object(forKey: "website_id") as? String)!
                                                if dictId == id {
                                                    
                                                    
                                                    self.websitetTextF.text = (dictWeb.object(forKey: "website_name") as? String)!
                                                    self.indexSelectedWebsite = i
                                                    self.pickerGroup.selectRow(self.indexSelectedWebsite, inComponent: 0, animated: false)
                                                    
                                                    break
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                
                                
                            })
                            
                            
                        }
                    }
                    else {
                        if let message = responseData.object(forKey: "message") as? String {
                            ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                        }
                    }
                }
                else {
                    
                }
                
                
            }
            else {

            }
            
        }, onFailure: { (error) in
            self.websiteDataArr = ["Error"]
            
                        DispatchQueue.main.async(execute: { () -> Void in
            
                            self.pickerWebsite.reloadAllComponents()
                        })
            print("Error2: \(error.localizedDescription)")
            
        })
        
    }

    func setDataForEdit() {
        if self.productData.count > 0 {
            
            textFirstName.text = self.productData.object(forKey:"firstname") as? String
            textLastName.text = self.productData.object(forKey:"lastname") as? String
            textEmailAdd.text = self.productData.object(forKey:"email") as? String
            //textPassword.text = self.productData.object(forKey:"email") as? String

        }
    }
    func cancelPicker(sender: UIButton) {
        
        var nameGroup = String()
        var nameWebsite = String()
        
        
        if let dictWeb = self.websiteDataArr.object(at: indexSelectedWebsite) as? NSDictionary {
            nameWebsite = (dictWeb.object(forKey: "website_name") as? String)!
        }
        else {
            nameWebsite = (self.websiteDataArr.object(at: indexSelectedWebsite) as? String)!
        }

        if let dictWeb = self.groupDataArr.object(at: indexSelectedGroup) as? NSDictionary {
            nameGroup = (dictWeb.object(forKey: "customer_group_code") as? String)!
        }
        else {
            nameGroup = (self.groupDataArr.object(at: indexSelectedGroup) as? String)!
        }
        if sender.tag == 2 {
            groupTextF.text = nameGroup

            self.pickerGroup.selectRow(indexSelectedGroup, inComponent: 0, animated: false)
            pickerGroup.reloadAllComponents()
            groupTextF.resignFirstResponder()

        }
        else {
            websitetTextF.text = nameWebsite
            
            self.pickerWebsite.selectRow(indexSelectedWebsite, inComponent: 0, animated: false)
            pickerWebsite.reloadAllComponents()
            websitetTextF.resignFirstResponder()

        }
        
    }
    func donePicker(sender: UIButton) {
        
        var nameWebsite = String()

        if let dictWeb = self.websiteDataArr.object(at: indexSelectedWebsite) as? NSDictionary {
            nameWebsite = (dictWeb.object(forKey: "website_name") as? String)!
        }
        else {
            nameWebsite = (self.websiteDataArr.object(at: indexSelectedWebsite) as? String)!
        }

        var nameGroup = String()
        if let dictG = self.groupDataArr.object(at: indexSelectedGroup) as? NSDictionary {
            nameGroup = (dictG.object(forKey: "customer_group_code") as? String)!
        }
        else {
            nameGroup = (self.groupDataArr.object(at: indexSelectedGroup) as? String)!
        }

        if sender.tag == 2 {
            groupTextF.text = nameGroup
            self.pickerGroup.selectRow(indexSelectedGroup, inComponent: 0, animated: false)
            pickerGroup.reloadAllComponents()
            groupTextF.resignFirstResponder()

        }
        else {
            websitetTextF.text = nameWebsite
            
            self.pickerWebsite.selectRow(indexSelectedWebsite, inComponent: 0, animated: false)
            pickerWebsite.reloadAllComponents()
            websitetTextF.resignFirstResponder()
 
        }
        
    }

    @IBAction func groupButtonTapped(_ sender: Any) {
        groupTextF.becomeFirstResponder()
    }
    @IBAction func websiteButtonTapped(_ sender: Any) {
        websitetTextF.becomeFirstResponder()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: textFirstName.text!) {
            ObjRef.sharedInstance.showAlertController(msg: "First Name is not correct", superVC: self)
            return
        }
        else if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: textLastName.text!) {
            ObjRef.sharedInstance.showAlertController(msg: "Last Name is not correct", superVC: self)
            return
        }
        else if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: textEmailAdd.text!) {
            ObjRef.sharedInstance.showAlertController(msg: "Email is not correct", superVC: self)
            return
        }
        else if (((textPassword.text?.trimmingCharacters(in: .whitespaces).characters.count)! == 0) && editBool == false) || (((textPassword.text?.trimmingCharacters(in: .whitespaces).characters.count)! > 0) && editBool == true) {
       // if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: textPassword.text!) {
            //if ((textPassword.text?.trimmingCharacters(in: .whitespaces).characters.count)! < 6) {
            ObjRef.sharedInstance.showAlertController(msg: "Password should contain atleat 6 characters", superVC: self)
            return
           // }
        //}
        }
//            if (textFirstName.text?.characters.count)! != 0 && (textLastName.text?.characters.count)! != 0 && (textEmailAdd.text?.characters.count)! != 0 && (((textPassword.text?.trimmingCharacters(in: .whitespaces).characters.count)! == 0) && editBool == false) || (((textPassword.text?.trimmingCharacters(in: .whitespaces).characters.count)! > 0) && editBool == true) {
        
                //http://magentoapp.newsoftdemo.info/adminapp/category/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&parent_id=4&name=test&is_active=1&description=testingtesting&image=hfg.jpg&include_in_menu=1
                
//                let dictParent = self.parentCatArr.object(at: indexSelected) as! NSDictionary
//                let parentId = dictParent.object(forKey: "category_id") as! String
//                
//                
//                
//              
                
                var groupId = String()
                
                if let dictWeb = self.groupDataArr.object(at: self.indexSelectedGroup) as? NSDictionary {
                    groupId = (dictWeb.object(forKey: "customer_group_id") as? String)!
                }
                
                let localDbUrl = "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                var dataPost = "firstname=" + textFirstName.text! + "&lastname=" + textLastName.text! + "&email=" +  textEmailAdd.text! + "&password=" +  textPassword.text! + "&group_id=" + groupId + "&website_id=1"
                if editBool == true {
                    dataPost = dataPost + "&edit_customer_id=" + (self.productData.object(forKey: "entity_id") as? String)!
                }
                self.submitCustomer(localDbUrl: localDbUrl, dataPost: dataPost)
                
            //}

    }
    
    func submitCustomer(localDbUrl:String,dataPost:String) {
        APIManager.sharedInstance.postRequestWithId(appendParam: localDbUrl, bodyData: dataPost, presentingView: self.view, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        if let message = responseData.object(forKey: "message") as? String {
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                if let message = responseData.object(forKey: "message") as? String {
                                    let alertCont = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                    alertCont.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                                        self.delegate.updateCustomerListing()
                                        _ = self.navigationController?.popViewController(animated: true)
                                    }))
                                    self.present(alertCont, animated: true, completion: nil)
                                }
                                
                            })                        }
                    }
                    else {
                        if let message = responseData.object(forKey: "message") as? String {
                            ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)

                        }
                    }
                }
                else {
                }
                
            }
            else {
                
                
            }
            
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            
        })

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

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerGroup {
            activeTextField = groupTextF
            return self.groupDataArr.count
        }
        else if pickerView == pickerWebsite {
            activeTextField = websitetTextF
            return self.websiteDataArr.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerGroup {
            if self.groupDataArr.count > row {
                
                if let dictWeb = self.groupDataArr.object(at: row) as? NSDictionary {
                    return dictWeb.object(forKey: "customer_group_code") as? String
                }
            }
            let name = self.groupDataArr.object(at: row) as? String
            return name
        }
        else if pickerView == pickerWebsite {
            if self.websiteDataArr.count > row {
                if let dictWeb = self.websiteDataArr.object(at: row) as? NSDictionary {
                    return dictWeb.object(forKey: "website_name") as? String
                }
            }
            let name = self.websiteDataArr.object(at: row) as? String
            return name
        }
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerGroup {
            indexSelectedGroup = row
        }
        else if pickerView == pickerWebsite {
            indexSelectedWebsite = row
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
