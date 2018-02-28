//
//  EditCategoryViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 08/12/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

@objc public protocol EditCategoryDelegate {
    func updateCategoryListing()
}

class EditCategoryViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    open weak var delegate: EditCategoryDelegate?

    var editBool = Bool()
    var catId = String()
    var parentCatName = String()
    var categoryData = NSDictionary()
    var parentCategoryData = NSDictionary()
    
    @IBOutlet var includeMenuSwitch: UISwitch!
    @IBOutlet var isActiveSwitch: UISwitch!
    @IBOutlet var includeMenuLab: UILabel!
    @IBOutlet var isActiveLab: UILabel!
    @IBOutlet var parentCatLab: UILabel!
    @IBOutlet var descLab: UILabel!
    @IBOutlet var nameLab: UILabel!
    @IBOutlet var textName: UITextField!
    var indexSelected = Int()

    @IBOutlet var parentCatButton: UIButton!
    @IBOutlet var categoryTextF: UITextField!
    @IBOutlet var textViewDesc: UITextView!
    var activeTextField : UITextField!
    var pickerCategory = UIPickerView()

    @IBOutlet var saveButton: UIButton!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!

    var parentCatArr = NSMutableArray()
    var catName = String()
    
    @IBAction func includeInMenuSwitchValueChange(_ sender: Any) {
        
    
    }
    @IBAction func isActiveSwitchValueChanged(_ sender: Any) {
        
        
    }
    func getEditCategoryData() {
        
        textName.text = self.categoryData.object(forKey: "name") as? String
        //textViewDesc.text = self.categoryData.object(forKey: "name") as! String
        //categoryTextF.text = self.categoryData.object(forKey: "name") as! String
        if let isActive = self.categoryData.object(forKey: "is_active") as? Int {
            if isActive == 1 {
                isActiveSwitch.isOn = true
            }
            else {
                isActiveSwitch.isOn = false
            }
        }
        
       // for i in 0  ..< parentCatArr.count  {
            //let dict = parentCatArr.object(at: 0) as! NSDictionary
           // if let id = dict.object(forKey: "parent_id") as? String {
               // if let idParent = self.categoryData.object(forKey: "category_id") as? String {
                   // if idParent == id {
                        indexSelected = 0
                        pickerCategory.selectRow(indexSelected, inComponent: 0, animated: false)
                        pickerCategory.reloadAllComponents()
        self.categoryTextF.text = self.parentCategoryData.object(forKey: "name") as? String
                       // self.donePicker(sender: UIButton())

                   // }
              //  }
                
            //}
            
       // }

//        let localDbUrl = "category/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&category_id=" + catId
//        
//        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
//            
//            if let responseData = json as? NSDictionary {
//                if let active = responseData.object(forKey: "active") as? Int {
//                    if active == 0 {
//                        if let message = responseData.object(forKey: "message") as? String {
//                            ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
//                        }
//                    }
//                    else {
//                        
//                    }
//                }
//                else {
//                }
//                
//            }
//            else {
//                
//                
//            }
//            
//        }, onFailure: { (error) in
//            print("Error2: \(error.localizedDescription)")
//            
//        })

    }
    @IBAction func saveTapped(_ sender: Any) {
        
        if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: textName.text!) {
            ObjRef.sharedInstance.showAlertController(msg: "Name is not correct", superVC: self)
            return
        }
        else if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: textViewDesc.text!) {
            ObjRef.sharedInstance.showAlertController(msg: "Description is not correct", superVC: self)
            return
        }
        if textName.text?.characters.count != 0 && textViewDesc.text?.characters.count != 0 {
            
            //http://magentoapp.newsoftdemo.info/adminapp/category/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&parent_id=4&name=test&is_active=1&description=testingtesting&image=hfg.jpg&include_in_menu=1
            
            let dictParent = self.parentCatArr.object(at: indexSelected) as! NSDictionary
            let parentId = dictParent.object(forKey: "category_id") as! String
            
            var activeInt = 0
            if isActiveSwitch.isOn == true {
                activeInt = 1
            }
            
            var includeMenu = 0
            if includeMenuSwitch.isOn == true {
                includeMenu = 1
            }
            
            let localDbUrl = "category/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            var dataPost = "name=" + textName.text! + "&is_active=\(activeInt)&description=" +  textViewDesc.text! + "&include_in_menu=\(includeMenu)&"
            if editBool == true {
                dataPost = dataPost + "category_id=" + (categoryData.object(forKey: "category_id") as? String)!
            }
            else {
                dataPost = dataPost + "parent_id=" + parentId
            }
            self.submitCategory(localDbUrl: localDbUrl, dataPost: dataPost)

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.catName
        
        if let children = self.parentCategoryData.object(forKey: "children") as? NSArray {
            self.parentCatArr = NSMutableArray()
            self.parentCatArr.add(self.parentCategoryData)
            self.parentCatArr.addObjects(from: children as! [Any])
        }
        textViewDesc.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        registerForKeyboardNotifications()
        
        pickerCategory.delegate = self
        pickerCategory.dataSource = self
        categoryTextF.inputView = pickerCategory
        
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
        
        categoryTextF.inputAccessoryView = toolBar
        categoryTextF.delegate = self
        
        pickerCategory.selectRow(indexSelected, inComponent: 0, animated: false)
        pickerCategory.reloadAllComponents()
        self.donePicker(sender: UIButton())
        viewHeightConst.constant = saveButton.frame.size.height + saveButton.frame.origin.y + 20
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: viewHeightConst.constant + 20)

        if editBool == true {
            self.getEditCategoryData()
        }
       //http://magentoapp.newsoftdemo.info/adminapp/category/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&parent_id=4&name=test&is_active=1&description=testingtesting&image=hfg.jpg&include_in_menu=1
        
        let fontSize = 14
        
        nameLab.font = ObjRef.sharedInstance.updateFont(fontName: (nameLab.font?.fontName)!, fontSize: fontSize)
        textName.font = ObjRef.sharedInstance.updateFont(fontName: (textName.font?.fontName)!, fontSize: fontSize)
        descLab.font = ObjRef.sharedInstance.updateFont(fontName: (descLab.font?.fontName)!, fontSize: fontSize)
        textViewDesc.font = ObjRef.sharedInstance.updateFont(fontName: (textViewDesc.font?.fontName)!, fontSize: fontSize)
        parentCatLab.font = ObjRef.sharedInstance.updateFont(fontName: (parentCatLab.font?.fontName)!, fontSize: fontSize)
        categoryTextF.font = ObjRef.sharedInstance.updateFont(fontName: (categoryTextF.font?.fontName)!, fontSize: fontSize)
        includeMenuLab.font = ObjRef.sharedInstance.updateFont(fontName: (includeMenuLab.font?.fontName)!, fontSize: fontSize)
        isActiveLab.font = ObjRef.sharedInstance.updateFont(fontName: (isActiveLab.font?.fontName)!, fontSize: fontSize)

        saveButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (saveButton.titleLabel?.font?.fontName)!, fontSize: fontSize)

        if editBool == true {
            self.categoryTextF.isUserInteractionEnabled = false
        }
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func cancelPicker(sender: UIButton) {
        
        let cellDict = self.parentCatArr.object(at: indexSelected) as! NSDictionary
        let name = cellDict.object(forKey: "name") as? String
        
        categoryTextF.text = name

        self.pickerCategory.selectRow(indexSelected, inComponent: 0, animated: false)
        pickerCategory.reloadAllComponents()
        
        categoryTextF.resignFirstResponder()
    }
    func donePicker(sender: UIButton) {
        
        let cellDict = self.parentCatArr.object(at: indexSelected) as! NSDictionary
        let name = cellDict.object(forKey: "name") as? String

        categoryTextF.text = name
        categoryTextF.resignFirstResponder()
        //enableProductApi()
        //
    }

    func submitCategory(localDbUrl : String,dataPost : String) {
        
        

        APIManager.sharedInstance.postRequestWithId(appendParam: localDbUrl, bodyData: dataPost, presentingView: self.view, onSuccess: { (json) in
    
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        if let message = responseData.object(forKey: "message") as? String {
                            let alertCont = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alertCont.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { (action) in
                                self.delegate?.updateCategoryListing()
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alertCont, animated: true, completion: nil)
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
    

    
    @IBAction func catButtonTapped(_ sender: Any) {
        
        categoryTextF.becomeFirstResponder()
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.parentCatArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let cellDict = self.parentCatArr.object(at: row) as! NSDictionary
        let name = cellDict.object(forKey: "name") as? String
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        indexSelected = row
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
