//
//  ProductDetailViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 11/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    @IBOutlet var viewHeightconst: NSLayoutConstraint!
    @IBOutlet var descView: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var contentV: UIView!
    @IBOutlet var noRevLab: UILabel!
    @IBOutlet var topRevButton: UIButton!
    @IBOutlet var labStockVal: UILabel!
    @IBOutlet var labStock: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var noReviewLab: UIView!
   // @IBOutlet var reviewTableView: UITableView!
    @IBOutlet var enableDisableTF: UITextField!
    @IBOutlet var productTitle: UILabel!
    
    @IBOutlet var productPrice: CurrencyLabel!
    
    @IBOutlet var prodDescLab: UILabel!
    
    var pickerEnableDisable = UIPickerView()
    
    var indexSelected = Int()
    var productDetail = NSDictionary()
    var reviewArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fontSize = 13
        
        self.productPrice.font = ObjRef.sharedInstance.updateFont(fontName: productPrice.font.fontName, fontSize: fontSize)
        self.productTitle.font = ObjRef.sharedInstance.updateFont(fontName: productTitle.font.fontName, fontSize: fontSize)
        self.prodDescLab.font = ObjRef.sharedInstance.updateFont(fontName: prodDescLab.font.fontName, fontSize: fontSize)
        self.labStock.font = ObjRef.sharedInstance.updateFont(fontName: labStock.font.fontName, fontSize: fontSize)
        self.labStockVal.font = ObjRef.sharedInstance.updateFont(fontName: labStockVal.font.fontName, fontSize: fontSize)
        self.enableDisableTF.font = ObjRef.sharedInstance.updateFont(fontName: (enableDisableTF.font?.fontName)!, fontSize: fontSize)
        //self.topRevButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (topRevButton.titleLabel?.font.fontName)!, fontSize: fontSize)
       // self.noRevLab.font = ObjRef.sharedInstance.updateFont(fontName: noRevLab.font.fontName, fontSize: fontSize)
        /*
 is salable = 0 --> out of stock,1
 status = 2 --> disabled , 1
 */
        
        productImage.layer.borderWidth = 2
        productImage.layer.cornerRadius = productImage.frame.size.width*0.5
        
        registerForKeyboardNotifications()

      //  self.reviewTableView.reloadData()
        APIManager.sharedInstance.getRequestWithId(appendParam: "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&product_id=\(self.productDetail["entity_id"]!)", presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            //            if let data = json as? NSDictionary {
            //                if let status = data["status"] as? String {
            //                    let msg = data["message"] as! String
            //                    if status == "error" {
            //                        UIAlertView(title: "Error", message: msg, delegate: nil, cancelButtonTitle: "ok")
            //                    }
            //                }
            //            }
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        if let data = responseData.object(forKey: "data") as? NSArray {
                            
                            self.productDetail = data.firstObject as! NSDictionary
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.updateData()
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
            
            _ = self.navigationController?.popViewController(animated: true)
        })

       // let searchImage = UIImage(named: "search")!
        
        let searchBtn: UIButton = UIButton()
        searchBtn.setTitle("Coupon", for: UIControlState.normal)
        searchBtn.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (searchBtn.titleLabel?.font.fontName)!, fontSize: 18)
       // searchBtn.setImage(searchImage, for: UIControlState.normal)
        searchBtn.addTarget(self, action: #selector(self.viewCoupon(sender:)), for: UIControlEvents.touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 80, height: (self.navigationController?.navigationBar.frame.size.height)!)
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        
//        self.navigationItem.setRightBarButtonItems([searchBarBtn], animated: false)

        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.reviewTableView.frame.size.height = self.reviewTableView.contentSize.height
//            self.scrollView.contentSize.height = self.reviewTableView.frame.origin.y + self.reviewTableView.frame.size.height + 10
//        }
        // Do any additional setup after loading the view.
    }
    func viewCoupon(sender : UIButton) {
        //
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CouponPage") as! CouponViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func updateData() {
        
        if let image = productDetail["image"] as? String {
            productImage.sd_setShowActivityIndicatorView(true)
            productImage.sd_setIndicatorStyle(.gray)
            
            productImage.sd_setImage(with: URL(string: image), completed: nil)
        }
        if let name = productDetail["name"] as? String {
            //productTitle.text = "dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads"
            productTitle.text = name
        }
        if let price = productDetail["price"] as? String {
            productPrice.text = price
            productPrice.updateCurrency(str: price)
        }
        if let sellable = productDetail["is_salable"] as? String {
            if sellable == "0" {
                labStockVal.text = "Out Of Stock"
            }
            else {
                labStockVal.text = "In Stock"
            }
        }
        //is_salable
        
        productTitle.sizeToFit()
        
        pickerEnableDisable.delegate = self
        pickerEnableDisable.dataSource = self
        enableDisableTF.inputView = pickerEnableDisable
        
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
        
        enableDisableTF.inputAccessoryView = toolBar
        enableDisableTF.delegate = self
        
        if let status = productDetail["status"] as? String {
            
            enableDisableTF.text = "Enabled"
            indexSelected = 0
            
            if status == "2" {
                enableDisableTF.text = "Disabled"
                indexSelected = 1
                
            }
        }
        pickerEnableDisable.selectRow(indexSelected, inComponent: 0, animated: false)
        pickerEnableDisable.reloadAllComponents()

        if let desc = productDetail["description"] as? String {
            prodDescLab.text = desc
        }
        //prodDescLab.text = "dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads dsfads dsfa dsfads"
        prodDescLab.sizeToFit()
        
        //contentV.frame.size.height = enableDisableTF.frame.origin.y + enableDisableTF.frame.size.height + 20
        viewHeightconst.constant = prodDescLab.frame.size.height + descView.frame.origin.y + 120
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: viewHeightconst.constant + 20)
    }
    @IBAction func enableDisableButtonTapped(_ sender: Any) {
        enableDisableTF.becomeFirstResponder()
    }
    
    func cancelPicker(sender: UIButton) {
        if enableDisableTF.text == "Enabled" {
            indexSelected = 0
        }
        else if enableDisableTF.text == "Disabled" {
            indexSelected = 1
        }
        self.pickerEnableDisable.selectRow(indexSelected, inComponent: 0, animated: false)
        pickerEnableDisable.reloadAllComponents()
        
        enableDisableTF.resignFirstResponder()
    }
    func donePicker(sender: UIButton) {
        if indexSelected == 0 {
            enableDisableTF.text = "Enabled"
        }
        else {
            enableDisableTF.text = "Disabled"
        }
        enableDisableTF.resignFirstResponder()
        enableProductApi()
        //
    }
    func enableProductApi() {
        var entintyId = ""
        var status = ""
        if let entity_id = productDetail["entity_id"] as? String {
            entintyId = entity_id
        }
        if let statusV = productDetail["status"] as? String {
            status = "2"

            if statusV == "2" {
                status = "1"
            }
        }
        let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&productId=\(entintyId)&status=\(status)"
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
           // sender.isSelected = false
            
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
                
            }
            else {
                
                if json.count > 0 {
                    if json is NSNull {
                        
                    }
                    else {
                        if json is NSDictionary {
                        }
                        else {
                            if json.object(at: 0) is NSNull {
                            }
                            else {
                                if let data = json.object(at: 0) as? NSDictionary {
                                    let msg = data.object(forKey: "message") as! String
                                    
                                    ObjRef.sharedInstance.showAlertController(msg: msg, superVC: self)

//                                    if data.count == 10 {
//                                        self.showLoadMore = true
//                                    }
//                                    else {
//                                        self.showLoadMore = false
//                                    }
//                                    self.customerData = json as! NSArray
//                                    self.userArr = NSMutableArray(array: data)
//                                    self.fullUserArr = self.userArr
//                                    DispatchQueue.main.async(execute: { () -> Void in
//                                        self.userTableView.reloadData()
//                                    })
                                }
                                
                            }
                        }
                    }
                    //self.userDataLoaded()
                }
            }
            
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            //sender.isSelected = false
            
        })

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)

    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(paste(_:))) || (action == #selector(copy(_:))) || (action == #selector(cut(_:))) || (action == #selector(select(_:))) || (action == #selector(selectAll(_:))) {
            return false;
        }
        return super.canPerformAction(action, withSender: sender)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
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
        if (enableDisableTF) != nil
        {
            if (!aRect.contains(enableDisableTF.frame.origin))
            {
                self.scrollView.scrollRectToVisible(enableDisableTF.frame, animated: true)
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

    @IBAction func ratingValueChanged(_ sender: Any) {
        
    }
    // MARK:- tableview deleatgate datasource
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return reviewArr.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductReviewTableViewCell
//        cell.selectionStyle = .none
//
//        /*
// HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
// starRatingView.maximumValue = 10;
// starRatingView.minimumValue = 0;
// starRatingView.value = 0;
// starRatingView.tintColor = [UIColor redColor];
// [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
// [self.view addSubview:starRatingView];
// */
//        let fontSize = 13
//        
//        cell.reviewTitle.font = ObjRef.sharedInstance.updateFont(fontName: (cell.reviewTitle.font?.fontName)!, fontSize: fontSize)
//        cell.reviewDesc.font = ObjRef.sharedInstance.updateFont(fontName: (cell.reviewDesc.font?.fontName)!, fontSize: fontSize)
//        cell.reviewName.font = ObjRef.sharedInstance.updateFont(fontName: (cell.reviewName.font?.fontName)!, fontSize: fontSize)
//        cell.approveButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (cell.approveButton.titleLabel?.font?.fontName)!, fontSize: fontSize)
//        cell.deleteButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (cell.deleteButton.titleLabel?.font?.fontName)!, fontSize: fontSize)
//        
//        cell.approveButton.layer.cornerRadius = cell.approveButton.frame.size.height*0.5
//        cell.deleteButton.layer.cornerRadius = cell.deleteButton.frame.size.height*0.5
//        
//        cell.userRating.maximumValue = 5
//        cell.userRating.minimumValue = 0
//        cell.userRating.value = 2
//        cell.userRating.tag = indexPath.row
//        cell.userRating.isUserInteractionEnabled = false
//        return cell
//        
//    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Enabled"
        }
        return "Disabled"
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
