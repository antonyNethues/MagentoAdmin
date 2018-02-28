//
//  EditProductViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 12/12/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

@objc public protocol EditProductDelegate {
    func updateProductListing()
}

class EditProductViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    open weak var delegate: EditProductDelegate?

    @IBOutlet var prodTableView: UITableView!
    
    var prodImageIndex = Int()
    
    var editBool = Bool()
    var prodId = String()
    var productName = String()
    var productData = NSDictionary()

    var websiteArr = NSArray()
    var statusArr = NSArray()
    var visibilityArr = NSArray()
    var taxClassArr = NSArray()
    var stockAvlArr = NSArray()
    var attListArr = NSArray()
    
    var websitePicker = CustomPicker()
    var statusPicker = CustomPicker()
    var visibilityPicker = CustomPicker()
    var taxClassPicker = CustomPicker()
    var stockAvlPicker = CustomPicker()
    var attPicker = CustomPicker()
    var currentActivePicker = CustomPicker()
    
    var activeTextField = UITextField()
    var activeTextView : UITextView!
    var imagePickerV = UIImagePickerController()
    var selectedImage : UIImage!
    var selectedImageViewEdit : UIImageView!

    var skuNotAvailable = Bool()
    
    var nameStr = String()
    var skuStr = String()
    var weightStr = String()
    var descStr = String()
    var shortDescStr = String()

    var statusVal = Int()
    var visibilityVal = Int()

    var priceStr = String()

    var quantStr = String()
    var stockAvlVal = Int()
    
    var catArr = NSArray()
    var websiteArrSelected = NSMutableArray()

    var prodImagesArr = NSMutableArray()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()

        self.title = productName
        
        self.skuNotAvailable = true
        
        attListArr = ["Loading..."]
        websiteArr = ["Loading..."]
        taxClassArr = ["Loading..."]
        statusArr = ["Enabled","Disabled"]
        stockAvlArr = ["In Stock","Out of Stock"]
        visibilityArr = ["Not Visible Individually","Catalog","Search","Catalog,Search"]
        
        DispatchQueue.global(qos: .background).sync {
            
            self.getWebsiteList()
            self.getAttList()
            self.getTaxClassList()
            
        }
        
        if editBool == true {
            self.getEditProductData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        

    }
    func getEditProductData() {
        
        nameStr = (self.productData.object(forKey: "name") as? String)!
        skuStr = (self.productData.object(forKey: "sku") as? String)!
        //weightStr = (self.productData.object(forKey: "sku") as? String)!
        descStr = (self.productData.object(forKey: "description") as? String)!
        shortDescStr = (self.productData.object(forKey: "short_description") as? String)!
        priceStr = (self.productData.object(forKey: "price") as? String)!
        weightStr = (self.productData.object(forKey: "weight") as? String)!
        quantStr = String(describing: self.productData.object(forKey: "qty") as! Int)

        if let category_ids = self.productData.object(forKey: "category_ids") as? NSArray {
            self.catArr = category_ids
        }

        if let status = self.productData.object(forKey: "status") as? String {
            if status == "1" {
                statusPicker.selectedIndexCommit = 0
            }
            else {
                statusPicker.selectedIndexCommit = 1
            }
        }
        
        if let sellable = self.productData["is_salable"] as? String {
            if sellable == "0" {
                stockAvlPicker.selectedIndexCommit = 1
            }
            else {
                stockAvlPicker.selectedIndexCommit = 0
            }
        }
        
        if let status = self.productData.object(forKey: "status") as? String {
            if status == "1" {
                statusPicker.selectedIndexCommit = 0
            }
            else {
                statusPicker.selectedIndexCommit = 1
            }
        }
        if let visibilityStr = self.productData.object(forKey: "visibility") as? String {
            visibilityPicker.selectedIndexCommit = Int(visibilityStr)! - 1
        }
        if let thumbnail = self.productData.object(forKey: "thumbnail") as? String {
            selectedImageViewEdit = UIImageView()
            selectedImageViewEdit.sd_setImage(with: URL(string: thumbnail), completed: { (image, error, imageType, url) in
                self.selectedImage = image
                self.prodTableView.reloadData()
            })
            //selectedImage = Int(visibilityStr)! - 1
        }
        self.prodTableView.reloadData()
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func getWebsiteList() {
        
        let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&websites=1"
        
        
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        
                        if let data = responseData.object(forKey: "data") as? NSArray {
                            self.websiteArr = data
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.websitePicker.reloadAllComponents()
                            })
                            if self.editBool == true {
                                if let statVal = self.productData.object(forKey: "website_id") as? String {
                                    for i in 0 ..< self.websiteArr.count {
                                        let attDict = self.websiteArr.object(at: i) as? NSDictionary
                                        let setId = attDict!["set_id"] as? String
                                        if setId == statVal {
                                            self.websitePicker.selectedIndexCommit = i
                                            break
                                        }
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: UITableViewRowAnimation.none)
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
            self.websiteArr = ["Error"]

            DispatchQueue.main.async(execute: { () -> Void in
                self.websitePicker.reloadAllComponents()

                self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: UITableViewRowAnimation.none)
            })
            print("Error2: \(error.localizedDescription)")
            
        })
        
    }
    func getAttList() {
        
        let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&attribute_set=1"
        
        
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
                    self.attListArr = responseData
                    //4
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

                    DispatchQueue.main.async(execute: { () -> Void in
                        self.attPicker.reloadAllComponents()

                        self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: UITableViewRowAnimation.none)
                    })
                }
            }
            
        }, onFailure: { (error) in
            self.attListArr = ["Error"]

            DispatchQueue.main.async(execute: { () -> Void in
                self.attPicker.reloadAllComponents()

                self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: UITableViewRowAnimation.none)
            })
            print("Error2: \(error.localizedDescription)")
            
        })
        
    }
    func getTaxClassList() {
        let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&tax_class=1"
        
        
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
                    self.taxClassArr = responseData
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
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.taxClassPicker.reloadAllComponents()

                        self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: UITableViewRowAnimation.none)
                    })
                }
            }
        }, onFailure: { (error) in
            self.taxClassArr = ["Error"]

            DispatchQueue.main.async(execute: { () -> Void in
                self.taxClassPicker.reloadAllComponents()

                self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: UITableViewRowAnimation.none)
            })

            print("Error2: \(error.localizedDescription)")
            
        })
        
    }
    
    func getSkuAvailability(textSku : String,textF :UITextField) {
        
        let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&sku_check=" + textSku
        
        
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "false" {
                        if let message = responseData.object(forKey: "message") as? String {
                            ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                        }
                        self.skuNotAvailable = true
                        textF.textColor = UIColor.red
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.none)
                        })

                    }
                    else {
                        self.skuNotAvailable = false
                        DispatchQueue.main.async(execute: { () -> Void in
                            textF.textColor = UIColor.black

                            self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.none)
                        })
                    }
                }
                else {
                    
                }
                
                
            }
            else {
                if let responseData = json as? NSArray {
                    self.attListArr = responseData
                    //4
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.attPicker.reloadAllComponents()

                        self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: UITableViewRowAnimation.none)
                    })
                }
            }
            
        }, onFailure: { (error) in
            self.attListArr = ["Error"]
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.attPicker.reloadAllComponents()

                self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: UITableViewRowAnimation.none)
            })
            print("Error2: \(error.localizedDescription)")
            
        })
        
    }

    @IBAction func addFileTapped(_ sender: Any) {
        
       
        
    }
    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; images=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    func isNumeric(str:String) -> Bool {
        guard str.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9","."]
        return Set(str.characters).isSubset(of: nums)
    }
    @IBAction func saveTapped(_ sender: Any) {
        
        if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: nameStr) {
            ObjRef.sharedInstance.showAlertController(msg: "Name is not correct", superVC: self)
            return
        }
        else if self.editBool == false {
            if self.skuNotAvailable == true {
                ObjRef.sharedInstance.showAlertController(msg: "Product with this sku already exists.", superVC: self)
                return
            }
        }
        else if !self.isNumeric(str: weightStr) {
            ObjRef.sharedInstance.showAlertController(msg: "Weight is not correct", superVC: self)
            return
        }
        else if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: descStr) {
            ObjRef.sharedInstance.showAlertController(msg: "Description is not correct", superVC: self)
            return
        }
        else if ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: shortDescStr) {
            ObjRef.sharedInstance.showAlertController(msg: "Short Description is not correct", superVC: self)
            return
        }
        else if !self.isNumeric(str: priceStr) {
            ObjRef.sharedInstance.showAlertController(msg: "Price is not correct", superVC: self)
            return
        }
        else if !self.isNumeric(str: quantStr) {
            ObjRef.sharedInstance.showAlertController(msg: "Quantity is not correct", superVC: self)
            return
        }
        else if self.websiteArrSelected.count == 0 {
            ObjRef.sharedInstance.showAlertController(msg: "Website is not Selected", superVC: self)
            return
        }
//        else if self.catArr.count == 0 {
//            ObjRef.sharedInstance.showAlertController(msg: "Category is not Selected", superVC: self)
//            return
//        }
        
        statusVal = 0
        visibilityVal = 0
        var taxClassApiVal = String()
        stockAvlVal = 0
        var websiteApiVal = String()
        var attApiVal = String()
        
        if statusPicker.selectedIndexCommit == 0 {
            statusVal = 1
        }

        if visibilityPicker.selectedIndexCommit == 0 {
            visibilityVal = 1
        }
        if stockAvlPicker.selectedIndexCommit == 0 {
            stockAvlVal = 1
        }
        if let taxVDict = taxClassArr.object(at: taxClassPicker.selectedIndexCommit) as? NSDictionary {
            if let idV = taxVDict.object(forKey: "class_id") as? String {
                taxClassApiVal = idV
            }
            
        }
        if let webVDict = websiteArr.object(at: websitePicker.selectedIndexCommit) as? NSDictionary {
            if let idV = webVDict.object(forKey: "website_id") as? String {
                websiteApiVal = idV
            }
        }
        
        if let attVDict = attListArr.object(at: attPicker.selectedIndexCommit) as? NSDictionary {
            if let idV = attVDict.object(forKey: "set_id") as? String {
                attApiVal = idV
            }
        }
        
         //http://magentoapp.newsoftdemo.info/adminapp/product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&product_category_id[]=11&product_category_id[]=12&websites[]=1&attributeSet_id=13&sku=kjd082&name=testagain5&description=sjjauyfdyuefuyef&short_description=djkfhgjvmmc&weight=1&status=1&price=100&tax_class_id=2&images[]=jhfyfy.jpg&quantity=10
        
//        if nameStr.characters.count > 0 && skuStr.characters.count > 0 && weightStr.characters.count > 0 && descStr.characters.count > 0 && shortDescStr.characters.count > 0 && priceStr.characters.count > 0 && quantStr.characters.count > 0 && catArr.count > 0 {
        if nameStr.characters.count > 0 && skuStr.characters.count > 0 && weightStr.characters.count > 0 && descStr.characters.count > 0 && shortDescStr.characters.count > 0 && priceStr.characters.count > 0 && quantStr.characters.count > 0 {

            let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
//            var dataPost = "name=" + nameStr + "&sku=" + skuStr + "&quantity=" +  quantStr + "&short_description=" +  shortDescStr + "&description=" +  descStr + "&weight=" +  weightStr + "&price=" +  priceStr + "&status=" +  "\(statusVal)" + "&tax_class_id=" +  taxClassApiVal + "&attributeSet_id=" +  attApiVal + "&websites=" +  "1" + "&product_category_id=11,12" +  catArr.componentsJoined(by: ",") + "&visibility=\(visibilityPicker.selectedIndexCommit + 1)"
            
            
            var params = NSMutableDictionary()
            params = ["name":nameStr,
                      "sku":skuStr,
                      "quantity":quantStr,
                      "short_description":shortDescStr,
                      "description":descStr,
                      "weight":weightStr,
                      "price":priceStr,
                      "status":"\(statusVal)",
                      "tax_class_id":taxClassApiVal,
                      "attributeSet_id":attApiVal,
                      "websites":websiteApiVal,
                      "visibility":"\(visibilityPicker.selectedIndexCommit + 1)",
                      "product_category_id":catArr.componentsJoined(by: ","),
                      "images[]" : prodImagesArr
            ]
            
            
            if self.editBool == true {
                params.addEntries(from: ["edit_product_id" : "1"])
            }


            
            self.createRequest(param: params, strURL: "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        }
    }
    
    
    
    
    func createRequest (param : NSMutableDictionary , strURL : String) {
        
        APIManager.sharedInstance.postRequestWithIdAndMultipart(appendParam: strURL, dataParam: param, presentingView: self.view, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        if let message = responseData.object(forKey: "message") as? String {
                            let alertCont = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alertCont.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { (action) in
                                self.delegate?.updateProductListing()
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
        }) { (error) in
            
            print("Error2: \(error.localizedDescription)")
            
        }
        //return request
    }
    @IBAction func CategoryTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryListing") as! ProductViewController
        vc.fromEditProduct = true
        vc.fromEditProductCatArr = NSMutableArray(array: catArr)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func websiteTapped(_ sender: Any) {
        
    }
    @IBAction func attSetButtonTapped(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            tableView.estimatedRowHeight = 662
            tableView.rowHeight = UITableViewAutomaticDimension
            
            
            return 1
        }
        else if section == 1 {
            tableView.estimatedRowHeight = 164
            tableView.rowHeight = UITableViewAutomaticDimension
            
            return 1
        }
        else if section == 2 {
            tableView.estimatedRowHeight = 164
            tableView.rowHeight = UITableViewAutomaticDimension
            return 1
        }
        else if section == 3 {
            tableView.estimatedRowHeight = 74
            tableView.rowHeight = UITableViewAutomaticDimension
            return 1
        }
        else if section == 4 {
            tableView.estimatedRowHeight = 74
            tableView.rowHeight = UITableViewAutomaticDimension
            //return self.websiteArr.count
            return self.websiteArr.count
        }
        else if section == 5 {
            tableView.estimatedRowHeight = 103
            tableView.rowHeight = UITableViewAutomaticDimension
            return 1
        }
        else if section == 6 {
            tableView.estimatedRowHeight = 125
            tableView.rowHeight = UITableViewAutomaticDimension
            return 1
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit1") as! EditProd1TableViewCell
        cell.selectionStyle = .none

        if cell.statusTextF.inputView == nil {
            self.setUpPickerView(picker: statusPicker, inputTextF: cell.statusTextF,tag: indexPath.section)
        }
        if cell.visibTextF.inputView == nil {
            self.setUpPickerView(picker: visibilityPicker, inputTextF: cell.visibTextF,tag: indexPath.section)
        }
        cell.statusTextF.text = statusArr.object(at: statusPicker.selectedIndexCommit) as? String
        cell.visibTextF.text = visibilityArr.object(at: visibilityPicker.selectedIndexCommit) as? String
        var fontSize = 14
        
        cell.nameLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.nameLab.font?.fontName)!, fontSize: fontSize)
        cell.nameTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.nameTextF.font?.fontName)!, fontSize: fontSize)
        cell.skuLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.skuLab.font?.fontName)!, fontSize: fontSize)
        cell.skuTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.skuTextF.font?.fontName)!, fontSize: fontSize)
        cell.weightLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.weightLab.font?.fontName)!, fontSize: fontSize)
        cell.weightTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.weightTextF.font?.fontName)!, fontSize: fontSize)
        cell.statusLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.statusLab.font?.fontName)!, fontSize: fontSize)
        cell.statusTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.statusTextF.font?.fontName)!, fontSize: fontSize)
        cell.visibLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.visibLab.font?.fontName)!, fontSize: fontSize)
        cell.visibTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.visibTextF.font?.fontName)!, fontSize: fontSize)
        cell.descLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.descLab.font?.fontName)!, fontSize: fontSize)
        cell.descTextv.font = ObjRef.sharedInstance.updateFont(fontName: (cell.descTextv.font?.fontName)!, fontSize: fontSize)
        cell.shortDesclab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.shortDesclab.font?.fontName)!, fontSize: fontSize)
        cell.shortDescTextv.font = ObjRef.sharedInstance.updateFont(fontName: (cell.shortDescTextv.font?.fontName)!, fontSize: fontSize)


        cell.descTextv.layer.borderWidth = 1
        cell.shortDescTextv.layer.borderWidth = 1
        
        
        cell.nameTextF.text! = nameStr
        cell.skuTextF.text! = skuStr
        cell.weightTextF.text! = weightStr
        cell.descTextv.text! = descStr
        cell.shortDescTextv.text! = shortDescStr
        
        if skuNotAvailable == true {
            if self.editBool == false {
                cell.skuTextF.textColor = UIColor.red
            }
            else {
                cell.skuTextF.isUserInteractionEnabled = false
            }
        }
        else {
            cell.skuTextF.textColor = UIColor.black
        }

        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit2") as! EditProd1TableViewCell
            cell.selectionStyle = .none

            if cell.taxClassTextF.inputView == nil {
                self.setUpPickerView(picker: taxClassPicker, inputTextF: cell.taxClassTextF,tag: indexPath.section)
            }
            if let dict = self.taxClassArr.object(at: self.taxClassPicker.selectedIndexCommit) as? NSDictionary {
                if let dictVal = dict.object(forKey: "class_name") as? String {

                cell.taxClassTextF.text = dictVal
                }
            }
            cell.priceLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.priceLab.font?.fontName)!, fontSize: fontSize)
            cell.priceTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.priceTextF.font?.fontName)!, fontSize: fontSize)
            cell.taxClassLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.taxClassLab.font?.fontName)!, fontSize: fontSize)
            cell.taxClassTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.taxClassTextF.font?.fontName)!, fontSize: fontSize)

            cell.priceTextF.text! = priceStr

        }
        else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit3") as! EditProd1TableViewCell
            cell.selectionStyle = .none

            if cell.stockAvlTextF.inputView == nil {
                self.setUpPickerView(picker: stockAvlPicker, inputTextF: cell.stockAvlTextF,tag: indexPath.section)
            }
            cell.stockAvlTextF.text = stockAvlArr.object(at: stockAvlPicker.selectedIndexCommit) as? String

            cell.quantityLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.quantityLab.font?.fontName)!, fontSize: fontSize)
            cell.quantityTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.quantityTextF.font?.fontName)!, fontSize: fontSize)
            cell.stockAvLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.stockAvLab.font?.fontName)!, fontSize: fontSize)
            cell.stockAvlTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.stockAvlTextF.font?.fontName)!, fontSize: fontSize)

            cell.quantityTextF.text! = quantStr

        }
        else if indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit4") as! EditProd1TableViewCell
            cell.selectionStyle = .none

            if cell.attSetTextF.inputView == nil {
                self.setUpPickerView(picker: attPicker, inputTextF: cell.attSetTextF,tag: indexPath.section)
            }
            if let dict = self.attListArr.object(at: self.attPicker.selectedIndexCommit) as? NSDictionary {
                if let dictVal = dict.object(forKey: "name") as? String {
                    
                    cell.attSetTextF.text = dictVal
                }
            }

            cell.attSetTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.attSetTextF.font?.fontName)!, fontSize: fontSize)

        }
        else if indexPath.section == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit7") as! EditProd1TableViewCell
            cell.selectionStyle = .none

//            if cell.websiteTextF.inputView == nil {
//                self.setUpPickerView(picker: websitePicker, inputTextF: cell.websiteTextF,tag: indexPath.section)
//            }
            if let dict = self.websiteArr.object(at: self.websitePicker.selectedIndexCommit) as? NSDictionary {
                if let dictVal = dict.object(forKey: "website_name") as? String {
                    
                    cell.websiteTextF.text = dictVal
                }
                let dictCell = dict
                let catId = dictCell.object(forKey: "website_id") as! String
                
                if websiteArrSelected.count > 0 {
                    var boolCheck = Bool()
                    
                    for i in 0  ..< websiteArrSelected.count  {
                        let obj = self.websiteArrSelected.object(at: i) as! String
                        if catId == obj {
                            cell.websiteButton.isSelected = true
                            boolCheck = true
                            break
                        }
                        else {
                            boolCheck = false
                            
                        }
                    }
                    if boolCheck == false {
                        cell.websiteButton.isSelected = false
                    }
                    
                }
                else {
                    cell.websiteButton.isSelected = false
                    
                }

            }
            else {
                
            }

            
            cell.websiteTextF.font = ObjRef.sharedInstance.updateFont(fontName: (cell.websiteTextF.font?.fontName)!, fontSize: fontSize)
        }
        else if indexPath.section == 5 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit5") as! EditProd1TableViewCell
            cell.selectionStyle = .none

            cell.imageCollectionView.reloadData()

        }
        else if indexPath.section == 6 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellEdit6") as! EditProd1TableViewCell
            cell.selectionStyle = .none

            cell.saveButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (cell.saveButton.titleLabel?.font?.fontName)!, fontSize: fontSize)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        headView.backgroundColor = ObjRef.sharedInstance.magentoGreen
        
        let labTitle = UILabel(frame: headView.frame)
        if section == 0 {
            labTitle.text = " General"
        }
        else if section == 1 {
            labTitle.text = " Prices"
        }
        else if section == 2 {
            labTitle.text = " Inventory"
        }
        else if section == 3 {
            labTitle.text = " Attribute Set"
        }
        else if section == 4 {
            labTitle.text = " Websites"
        }
        else if section == 5 {
            labTitle.text = " Image"
        }
        else if section == 6 {
            labTitle.text = " Category"
        }
        headView.addSubview(labTitle)
        labTitle.textColor = UIColor.white
        
        return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 4 {
            let cell = tableView.cellForRow(at: indexPath) as! EditProd1TableViewCell
            
            if cell.reuseIdentifier == "cellEdit7" {
                cell.websiteButton.isSelected = !cell.websiteButton.isSelected
                
                
                let dictCell = self.websiteArr.object(at: indexPath.row) as? NSDictionary
                var catId = String()
                
                if let id = dictCell?.object(forKey: "website_id") as? String {
                    catId = id
                }
                else {
                    return
                }
                
                if websiteArrSelected.count > 0 {
                    var boolCheck = Bool()
                    
                    for i in 0  ..< websiteArrSelected.count  {
                        let obj = self.websiteArrSelected.object(at: i) as! String
                        if catId == obj {
                            cell.websiteButton.isSelected = false
                            websiteArrSelected.removeObject(at: i)
                            boolCheck = true
                            break
                        }
                        else {
                            boolCheck = false
                            
                        }
                    }
                    if boolCheck == false {
                        websiteArrSelected.add(catId)
                        cell.websiteButton.isSelected = true
                    }
                    
                }
                else {
                    websiteArrSelected.add(catId)
                    cell.websiteButton.isSelected = true
                    
                }

                self.prodTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
            }
            
        }
    }
    //MARK:- collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return prodImagesArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! prodImageCollectionViewCell
        if prodImagesArr.count > 0 && indexPath.row > 0 {
            let image = prodImagesArr.object(at: indexPath.row - 1) as? UIImage
            cell.prodImageView.image = image
            cell.removeImageButton.isHidden = false

        }
        else if indexPath.row == 0 {
            cell.prodImageView.image = UIImage()
            cell.removeImageButton.isHidden = true
        }
        cell.addImageButton.tag = indexPath.row
        cell.removeImageButton.tag = indexPath.row
        
        return cell
    }
    //MARK:- imagepicker
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImage = chosenImage
        // use the image
        if prodImageIndex == 0 || self.prodImagesArr.count == 0 {
            self.prodImagesArr.add(selectedImage)
        }
        else {
            self.prodImagesArr.replaceObject(at: prodImageIndex - 1, with: selectedImage)
        }
        //DispatchQueue.main.async(execute: { () -> Void in

            self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: 5)], with: UITableViewRowAnimation.none)
       // })
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    //MARK:- keyboard handle
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
        self.prodTableView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.prodTableView.contentInset = contentInsets
        self.prodTableView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        
        if activeTextView != nil {
            if (!aRect.contains(activeTextView.frame.origin))
            {
                self.prodTableView.scrollRectToVisible(activeTextView.frame, animated: true)
            }
        }
        
        else if (!aRect.contains(self.prodTableView.convert(activeTextField.frame, from:activeTextField.superview).origin))
        {
            self.prodTableView.scrollRectToVisible(self.prodTableView.convert(activeTextField.frame, from:activeTextField.superview), animated: true)
        }
        
        
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        _ = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.prodTableView.contentInset = contentInsets
        self.prodTableView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        //self.scrollView.isScrollEnabled = false
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextView = nil
        activeTextField = textField
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let superCell = textField.superview?.superview as? EditProd1TableViewCell {
            if superCell.reuseIdentifier == "cellEdit1" {
                if superCell.nameTextF == textField {
                    nameStr = textField.text!
                }
                else if superCell.skuTextF == textField {
                    skuStr = textField.text!
                    if !ObjRef.sharedInstance.isEmptyOrContainsOnlySpaces(str: skuStr) {
                        self.getSkuAvailability(textSku: skuStr,textF: textField)
                    }
                }
                else if superCell.weightTextF == textField {
                    weightStr = textField.text!
                }
            }
            if superCell.reuseIdentifier == "cellEdit2" {

            if superCell.priceTextF == textField {
                priceStr = textField.text!
            }
            }
            if superCell.reuseIdentifier == "cellEdit3" {

            if superCell.quantityTextF == textField {
                quantStr = textField.text!
            }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let superCell = textView.superview?.superview as? EditProd1TableViewCell {
            if superCell.descTextv == textView {
                descStr = textView.text!
            }
            else if superCell.shortDescTextv == textView {
                shortDescStr = textView.text!
            }
            
        }

        activeTextView = textView
        if text == "\n" {
            activeTextView = nil

            textView.resignFirstResponder()
            return true
        }
        return true
    }
    
    //MARK:- picker delegate datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        currentActivePicker = pickerView as! CustomPicker
        
        if pickerView == websitePicker {
            return websiteArr.count
        }
        else if pickerView == statusPicker {
            return statusArr.count
        }
        else if pickerView == visibilityPicker {
            return visibilityArr.count
        }
        else if pickerView == taxClassPicker {
            return taxClassArr.count
        }
        else if pickerView == stockAvlPicker {
            return stockAvlArr.count
        }
        else if pickerView == attPicker {
            return attListArr.count
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let cellDict = NSDictionary()
        if pickerView == websitePicker {
            if let dict = self.websiteArr.object(at: row) as? NSDictionary {
                if let dictVal = dict.object(forKey: "website_name") as? String {
                    
                    return dictVal
                }
            }

            return websiteArr.object(at: row) as? String
        }
        else if pickerView == statusPicker {
            return statusArr.object(at: row) as? String
        }
        else if pickerView == visibilityPicker {
            return visibilityArr.object(at: row) as? String
        }
        else if pickerView == stockAvlPicker {
            return stockAvlArr.object(at: row) as? String
        }
        else if pickerView == taxClassPicker {
            if let dict = self.taxClassArr.object(at: row) as? NSDictionary {
                if let dictVal = dict.object(forKey: "class_name") as? String {
                    
                    return dictVal
                }
            }
            return taxClassArr.object(at: row) as? String
        }
        else if pickerView == attPicker {
            if let dict = self.attListArr.object(at: row) as? NSDictionary {
                if let dictVal = dict.object(forKey: "name") as? String {
                    
                    return dictVal
                }
            }

            return attListArr.object(at: row) as? String
        }

        let name = cellDict.object(forKey: "name") as? String
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == websitePicker {
            websitePicker.selectedIndex = row
        }
        else if pickerView == statusPicker {
            statusPicker.selectedIndex = row
        }
        else if pickerView == visibilityPicker {
            visibilityPicker.selectedIndex = row
        }
        else if pickerView == taxClassPicker {
            taxClassPicker.selectedIndex = row
        }
        else if pickerView == stockAvlPicker {
            stockAvlPicker.selectedIndex = row
        }
        else if pickerView == attPicker {
            attPicker.selectedIndex = row
        }
    }
    func setUpPickerView(picker : UIPickerView,inputTextF:UITextField,tag : Int) {
        
        picker.delegate = self
        picker.dataSource = self
        inputTextF.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = ObjRef.sharedInstance.magentoGreen
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker(sender:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelPicker(sender:)))
        
        doneButton.tag = tag
        cancelButton.tag = tag
        
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputTextF.inputAccessoryView = toolBar
        inputTextF.delegate = self
        
    }
    
    func cancelPicker(sender: UIButton) {
        
        currentActivePicker.resignFirstResponder()
        if currentActivePicker == websitePicker {
            self.websitePicker.selectedIndex = self.websitePicker.selectedIndexCommit
        }
        else if currentActivePicker == statusPicker {
            self.statusPicker.selectedIndex = self.statusPicker.selectedIndexCommit
        }
        else if currentActivePicker == visibilityPicker {
            self.visibilityPicker.selectedIndex = self.visibilityPicker.selectedIndexCommit
        }
        else if currentActivePicker == stockAvlPicker {
            self.stockAvlPicker.selectedIndex = self.stockAvlPicker.selectedIndexCommit
        }
        else if currentActivePicker == taxClassPicker {
            self.taxClassPicker.selectedIndex = self.taxClassPicker.selectedIndexCommit
        }
        else if currentActivePicker == attPicker {
            self.attPicker.selectedIndex = self.attPicker.selectedIndexCommit
        }
        
        self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: sender.tag)], with: UITableViewRowAnimation.none)

        
    }
    func donePicker(sender: UIButton) {
        
        currentActivePicker.resignFirstResponder()
        
        if currentActivePicker == websitePicker {
            self.websitePicker.selectedIndexCommit = self.websitePicker.selectedIndex
        }
        else if currentActivePicker == statusPicker {
            self.statusPicker.selectedIndexCommit = self.statusPicker.selectedIndex
        }
        else if currentActivePicker == visibilityPicker {
            self.visibilityPicker.selectedIndexCommit = self.visibilityPicker.selectedIndex
            
        }
        else if currentActivePicker == taxClassPicker {
            self.taxClassPicker.selectedIndexCommit = self.taxClassPicker.selectedIndex
        }
        else if currentActivePicker == attPicker {
            self.attPicker.selectedIndexCommit = self.attPicker.selectedIndex
        }
        else if currentActivePicker == stockAvlPicker {
            self.stockAvlPicker.selectedIndexCommit = self.stockAvlPicker.selectedIndex
            
        }
        
        self.prodTableView.reloadRows(at: [IndexPath(row: 0, section: sender.tag)], with: UITableViewRowAnimation.none)

        
    }
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        
        prodImageIndex = sender.tag

        let alertCont = UIAlertController(title: "", message: "Remove Image", preferredStyle: UIAlertControllerStyle.alert)
        alertCont.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.prodImagesArr.removeObject(at: self.prodImageIndex - 1)
            self.prodTableView.reloadData()
            
        }))
        
        alertCont.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
           
            
        }))
        
        self.present(alertCont, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        prodImageIndex = sender.tag
        
        imagePickerV.delegate = self
        
        let actionSheetCont = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheetCont.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.imagePickerV.allowsEditing = false
            self.imagePickerV.sourceType = .photoLibrary
            self.present(self.imagePickerV, animated: true, completion: nil)
            
        }))
        
        actionSheetCont.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                self.imagePickerV.allowsEditing = false
                self.imagePickerV.sourceType = .camera
                self.imagePickerV.cameraCaptureMode = .photo
                self.present(self.imagePickerV, animated: true, completion: nil)
            }
            
        }))
        
        self.present(actionSheetCont, animated: true, completion: nil)
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
