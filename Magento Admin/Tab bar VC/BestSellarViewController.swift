//
//  BestSellarViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 18/09/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class BestSellarViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var yearButton: UIButton!
    @IBOutlet var monthButton: UIButton!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var sellarTableView: UITableView!
    
    var pickerYear = UIPickerView()
    var pickerMonth = UIPickerView()
    var inputViewStart = UIView()
    var inputViewEnd = UIView()
    var localDBObj = FMDatabase()
    
    var currentIndex = Int()
    
    var showLoadMore = Bool()
    var dataLoaded = Bool()
    
    var bestSellarArr = NSMutableArray()
    
    var monthArr = NSMutableArray()
    var yearArr = NSMutableArray()
    var yearIndex = Int()
    var monthIndex = Int()
    var doneButton = UIButton()
    var doneButton2 = UIButton()
    var productData = NSArray()
    
    var productArr = NSMutableArray()
    
    var currentMonthIndex = Int()
    var currentYearIndex = Int()
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = ""
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.title = "Best Sellar"
        
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        ObjRef.sharedInstance.setupNavigationBar(vc: self)
        
        
        if let vc = self.parent?.parent as? HomeViewController {
            let height = vc.customTabBar.frame.size.height
            
            let heightSuper = self.view.frame.size.height
            let widthSuper = self.view.frame.size.width
            var heightMin = CGFloat()
            heightMin = widthSuper
            
            if heightSuper < widthSuper {
                heightMin = heightSuper
            }
            
            let withoutDonePicker = heightMin*0.35
            let withDonePicker = heightMin*0.425
            
            inputViewEnd.frame = CGRect(x: 0, y: self.view.frame.size.height - withDonePicker - height, width: self.view.frame.width, height: withDonePicker)
            pickerMonth.frame = CGRect(x: 0, y: withDonePicker - withoutDonePicker, width: view.frame.size.width, height: withoutDonePicker)
            
            inputViewStart.frame = CGRect(x: 0, y: self.view.frame.size.height - withDonePicker - height, width: self.view.frame.width, height: withDonePicker)
            pickerYear.frame = CGRect(x: 0, y: withDonePicker - withoutDonePicker, width: view.frame.size.width, height: withoutDonePicker)
            
            doneButton.frame = CGRect(x: (self.view.frame.size.width) - (110), y: 0, width: 100, height: withDonePicker - withoutDonePicker)
            doneButton2.frame = CGRect(x: (self.view.frame.size.width) - (110), y: 0, width: 100, height: withDonePicker - withoutDonePicker)
            
            doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
            doneButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
            
            doneButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (doneButton.titleLabel?.font.fontName)!, fontSize: 15)
            doneButton2.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (doneButton2.titleLabel?.font.fontName)!, fontSize: 15)
            
            inputViewStart.layer.masksToBounds = false;
            inputViewStart.layer.shadowOffset = CGSize(width: 5, height: 5)
            inputViewStart.layer.shadowRadius = 5
            inputViewStart.layer.shadowOpacity = 0.5
            
            inputViewEnd.layer.masksToBounds = false;
            inputViewEnd.layer.shadowOffset = CGSize(width: 5, height: 5)
            inputViewEnd.layer.shadowRadius = 5
            inputViewEnd.layer.shadowOpacity = 0.5
        }

        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
    }
    func navigationBtnLeftTapped() {
        let vcHome = self.parent?.parent as! HomeViewController
        vcHome.tabBar(vcHome.customTabBar, didSelect: vcHome.customTabBar.selectedItem!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        yearLabel.layer.borderWidth = 1
        monthLabel.layer.borderWidth = 1
        
        monthArr = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        
        let date = Date()
        
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        monthIndex = calendar.component(.month, from: date) - 1
        yearIndex = 0
        
        currentMonthIndex = monthIndex
        currentYearIndex = yearIndex
        
        for i in 0  ..< 10  {
            let newYear = year - i
            yearArr.add("\(newYear)")
        }
        
        yearLabel.text = yearArr.object(at: yearIndex) as? String
        monthLabel.text = monthArr.object(at: monthIndex) as? String
        let fontSize = 13
        
        yearLabel.font = ObjRef.sharedInstance.updateFont(fontName: yearLabel.font.fontName, fontSize: fontSize)
        monthLabel.font = ObjRef.sharedInstance.updateFont(fontName: monthLabel.font.fontName, fontSize: fontSize)
        
        inputViewStart = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.width, height: 240))
        inputViewStart.backgroundColor = UIColor.white
        
        pickerYear = UIPickerView(frame: CGRect(x: 0, y: 40, width: view.frame.size.width, height: 200))
        pickerYear.backgroundColor = UIColor.white
        
        pickerYear.showsSelectionIndicator = true
        pickerYear.delegate = self
        pickerYear.dataSource = self
        
        inputViewStart.addSubview(pickerYear)
        
        
        doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width) - (100), y: 0, width: 100, height: 40))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        doneButton.addTarget(self, action: #selector(self.doneStartPickerTapped(sender:)), for: UIControlEvents.touchUpInside)
        inputViewStart.addSubview(doneButton) // add Button to UIView
        
        self.view.addSubview(inputViewStart)
        self.view.bringSubview(toFront: inputViewStart)
        inputViewStart.isHidden = true
        
        
        //end picker
        
        inputViewEnd = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.width, height: 240))
        inputViewEnd.backgroundColor = UIColor.white
        
        pickerMonth = UIPickerView(frame: CGRect(x: 0, y: 40, width: view.frame.size.width, height: 200))
        pickerMonth.backgroundColor = UIColor.white
        
        pickerMonth.showsSelectionIndicator = true
        pickerMonth.delegate = self
        pickerMonth.dataSource = self
        
        inputViewEnd.addSubview(pickerMonth)
        
        
        doneButton2 = UIButton(frame: CGRect(x: (self.view.frame.size.width) - (100), y: 0, width: 100, height: 40))
        doneButton2.setTitle("Done", for: UIControlState.normal)
        doneButton2.setTitle("Done", for: UIControlState.highlighted)
        doneButton2.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton2.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        doneButton2.addTarget(self, action: #selector(self.doneEndPickerTapped(sender:)), for: UIControlEvents.touchUpInside)
        inputViewEnd.addSubview(doneButton2) // add Button to UIView
        
        self.view.addSubview(inputViewEnd)
        self.view.bringSubview(toFront: inputViewEnd)
        inputViewEnd.isHidden = true
        
        
        pickerYear.selectRow(yearIndex, inComponent: 0, animated: false)
        pickerMonth.selectRow(monthIndex, inComponent: 0, animated: false)
        
        
        localDBObj = MagentoDatabase.sharedInstance.MagentoDB
        DispatchQueue.global(qos: .background).sync {
            
            if (self.localDBObj.open()) {
                
                let dropTable = "DELETE FROM PRODUCTS"
                let result = self.localDBObj.executeUpdate(dropTable, withArgumentsIn: [])
                if !result {
                    print("Error: \(self.localDBObj.lastErrorMessage())")
                }
                //localDBObj.close()
                
            }
        }
        _ = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        //DispatchQueue.main.asyncAfter(deadline: when) {
        self.loadNewDataWithLocalUpdate(sender: UIButton())
        //}
        
        // Do any additional setup after loading the view.
    }
    func loadNewDataWithLocalUpdate(sender : UIButton) {
        
        self.dataLoaded = false
        self.currentIndex = 1
        let date = Date()
        let calendar = Calendar.current
        
        _ = calendar.component(.year, from: date)
        _ = calendar.component(.month, from: date) - 1
        
        var localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&"
        //month=4&year=2013&bestseller=1
        if monthIndex > 0 {
            if monthIndex > 9 {
                localDbUrl = localDbUrl + "month=\(monthIndex)&"
            }
            else {
                localDbUrl = localDbUrl + "month=0\(monthIndex)&"
            }
        }
        
        //if yearIndex > 0 {
        localDbUrl = localDbUrl + "year=\(yearLabel.text!)&"
        // }
        
        localDbUrl = localDbUrl + "bestseller=1"
        
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            sender.isSelected = false
            
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
                                if let data = json as? NSArray {
                                    if data.count == 10 {
                                        self.showLoadMore = true
                                    }
                                    else {
                                        self.showLoadMore = false
                                    }//productData
                                    self.productData = json as! NSArray
                                    self.bestSellarArr = NSMutableArray(array: data)
                                    //self.fullproductArr = self.productArr
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        self.sellarTableView.reloadData()
                                    })
                                }
                                
                            }
                        }
                    }
                    //self.userDataLoaded()
                }
            }
            
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            sender.isSelected = false
            
        })
        
        //database local
        
        // return
        
        
        
        DispatchQueue.global(qos: .background).sync {
            
            if (localDBObj.open()) {
                // let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                let sql_stmt = "CREATE TABLE IF NOT EXISTS PRODUCTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, FIRSTNAME TEXT, LASTNAME TEXT, ENTITYID TEXT, EMAIL TEXT, MONTH TEXT, UPDATED TEXT)"
                if !(localDBObj.executeStatements(sql_stmt)) {
                    print("Error: \(localDBObj.lastErrorMessage())")
                }
                //localDBObj.close()
            } else {
                print("Error: \(localDBObj.lastErrorMessage())")
            }

            print("This is run on the background queue")
            
            let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            
            let date = Date()
            
            
            let calendar = Calendar.current
            
            _ = calendar.component(.year, from: date)
            _ = calendar.component(.month, from: date) - 1
            
            
            APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : false, onSuccess: { (json) in
                
                if let responseData = json as? NSDictionary {
                    self.dataLoaded = true
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
                        if let data = json as? NSDictionary {
                            DispatchQueue.global(qos: .background).sync {
                                self.productData = NSArray(object: data)
                                self.userDataLoaded(totalArr: NSArray(object: data))
                            }
                        }
                        else {
                            DispatchQueue.global(qos: .background).sync {
                                self.productData = json as! NSArray
                                
                                self.userDataLoaded(totalArr: self.productData)
                            }
                        }
                    }
                }
                
            }, onFailure: { (error) in
                print("Error2: \(error.localizedDescription)")
                self.dataLoaded = true
                
            })
            
            
        }
        
    }
    func userDataLoaded(totalArr : NSArray) {
        //database local
        
        
        
        if (localDBObj.open()) {
            //(ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, ID TEXT, EMAIL TEXT, MONTH TEXT, YEAR TEXT)
            for i in 0  ..< totalArr.count {
                let dict = totalArr.object(at: i) as! NSDictionary
                
                var price = String()
                var imagelink = String()
                var thumbImagelink = String()
                var desc = String()
                var status = String()
                var stock = String()
                var name = String()
                var created_at = String()
                var updated_at = String()
                var entityId = String()
                
                if let priceV = dict["price"] as? String {
                    price = priceV
                }
                if let thumbnail = dict["thumbnail"] as? String {
                    thumbImagelink = thumbnail
                }
                if let image = dict["image"] as? String {
                    imagelink = image
                }
                if let description = dict["description"] as? String {
                    desc = description
                }
                if let statusV = dict["status"] as? String {
                    status = statusV
                }
                if let is_salable = dict["is_salable"] as? String {
                    stock = is_salable
                }
                if let nameV = dict["name"] as? String {
                    name = nameV
                }
                if let created_atV = dict["created_at"] as? String {
                    created_at = created_atV
                }
                if let updated_atV = dict["updated_at"] as? String {
                    updated_at = updated_atV
                }
                if let entity_id = dict["entity_id"] as? String {
                    entityId = entity_id
                }
                //
                //                let calendar = Calendar.current
                //                let month = calendar.component(.month, from: date!)
                //                let year = calendar.component(.year, from: date!)
                
                //let month2 = calendar.component(.month, from: date2!)
                //let year2 = calendar.component(.year, from: date2!)
                //CREATE TABLE IF NOT EXISTS PRODUCTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PRICE INTEGERF, IMAGELINK TEXT, THUMBIMAGELINK TEXT, DESC TEXT, STATUS TEXT, STOCK TEXT
                
                let insertSQL = "INSERT INTO PRODUCTS (entityid,name,price,imagelink,thumbimagelink,desc,status,stock,created_at,updated_at) VALUES ('\(entityId)','\(name)','\(price)','\(imagelink)','\(thumbImagelink)','\(desc)','\(status)','\(stock)','\(created_at)','\(updated_at)')"
                if !(localDBObj.executeStatements(insertSQL)) {
                    print("Error: \(localDBObj.lastErrorMessage())")
                }
                else {
                    print("conatct added")
                }
            }
            if totalArr.count > 0 {
                dataLoaded = true
            }
            // localDBObj.close()
            
            
        } else {
            print("Error: \(localDBObj.lastErrorMessage())")
            dataLoaded = true
            
        }
        
    }
    
    @IBAction func searchFilterTapped(_ sender: Any) {
        
        //        if sender is UIButton {
        //
        //            if (sender as! UIButton).isSelected == true {
        //                return
        //            }
        //            (sender as! UIButton).isSelected = true
        //
        //            if filterValChanged == true {
        //                filterValChanged = false
        //                self.currentIndex = 0
        //            }
        //            else if sender is UIButton {
        //                //return
        //            }
        //            if sender is UIButton {
        //                self.currentIndex = 0
        //                self.userArr = NSMutableArray()
        //
        //            }
        //        }
        
        // backFromSearchFilter = false
        var querySQL = "SELECT * FROM PRODUCTS WHERE "
        //var querySQL = "SELECT * FROM PRODUCTS "
        //SELECT * FROM table WHERE
        var checkAccess = Int()
        checkAccess = 0
        
        
        
        //if yearIndex > 0 {
        querySQL = querySQL + "created_at Like '\(yearLabel.text!)%' AND "
        checkAccess = 1
        //}
        
        
        if monthIndex > 0 {
            if monthIndex > 9 {
                querySQL = querySQL + "created_at Like '_____\(monthIndex)%' "
            }
            else {
                querySQL = querySQL + "created_at Like '_____0\(monthIndex)%' "
            }
        }
        else if checkAccess == 1 {
            let endIndex = querySQL.index(querySQL.endIndex, offsetBy: -4)
            let truncated = querySQL.substring(to: endIndex)
            
            querySQL = truncated
        }
        else if checkAccess == 0 {
            
            querySQL = "SELECT * FROM PRODUCTS "
            
        }
        
        if self.currentIndex == 1 {
            self.bestSellarArr = NSMutableArray()
        }
        querySQL = querySQL + "LIMIT 10 OFFSET \(self.currentIndex*10)"
        
        if (self.localDBObj.open()) {
            // let querySQL = "SELECT * FROM MAGENTO WHERE username Like '%Jane%',month Like '_____07%' , year '2017%'"
            //let querySQL = "SELECT * FROM MAGENTO WHERE month Like '_____09%' AND year Like '2017%'"
            //let querySQL = "SELECT * FROM MAGENTO"
            
            do {
                let results = try self.localDBObj.executeQuery(querySQL, values: [])
                //self.userArr = NSMutableArray()
                
                var counter = Int()
                counter = 0
                // your logic
                while results.next() == true {
                    counter += 1
                    // print(results.string(forColumn: "username")!)
                    //print(results.resultDictionary!)
                    /*
                     
                     if let priceV = dict["price"] as? String {
                     price = priceV
                     }
                     if let thumbnail = dict["thumbnail"] as? String {
                     thumbImagelink = thumbnail
                     }
                     if let image = dict["image"] as? String {
                     imagelink = image
                     }
                     if let description = dict["description"] as? String {
                     desc = description
                     }
                     if let statusV = dict["status"] as? String {
                     status = statusV
                     }
                     if let is_salable = dict["is_salable"] as? String {
                     stock = is_salable
                     }
                     if let nameV = dict["name"] as? String {
                     name = nameV
                     }
                     if let created_atV = dict["created_at"] as? String {
                     created_at = created_atV
                     }
                     if let updated_atV = dict["updated_at"] as? String {
                     updated_at = updated_atV
                     }
                     if let entity_id = dict["entity_id"] as? String {
                     entityId = entity_id
                     }
                     
                     let insertSQL = "INSERT INTO PRODUCTS (entityid,name,price,imagelink,thumbimagelink,desc,status,stock,created_at,updated_at) VALUES ('\(entityId)','\(name)','\(price)','\(imagelink)','\(stock)','\(desc)','\(status)','\(imagelink)','\(created_at)','\(updated_at)')"
                     */
                    let dict = [
                        "entity_id" : results.string(forColumn: "entityid"),
                        "name" : results.string(forColumn: "name"),
                        "price" : results.string(forColumn: "price"),
                        "image" : results.string(forColumn: "imagelink"),
                        "thumbnail" : results.string(forColumn: "thumbimagelink"),
                        "description" : results.string(forColumn: "desc"),
                        "status" : results.string(forColumn: "status"),
                        "is_salable" : results.string(forColumn: "stock"),
                        "created_at" : results.string(forColumn: "created_at"),
                        "updated_at" : results.string(forColumn: "updated_at")
                    ]
                    
                    self.bestSellarArr.add(dict)
                }
                
                if counter == 10 {
                    self.showLoadMore = true
                }
                else {
                    self.showLoadMore = false
                }
                if counter == 0 {
                    self.bestSellarArr = NSMutableArray()
                    
                }
                self.sellarTableView.reloadData()
                results.close()
                if sender is UIButton {
                    
                    (sender as! UIButton).isSelected = false
                }
            }
            catch {
                print("error\(error.localizedDescription)")
                if sender is UIButton {
                    
                    (sender as! UIButton).isSelected = false
                }
            }
            //           // let results:FMResultSet? = contactDB.executeQuery(querySQL,
            //                                                               withArgumentsIn: [])
            
            
            //self.localDBObj.close()
        } else {
            print("Error: \(self.localDBObj.lastErrorMessage())")
            if sender is UIButton {
                
                (sender as! UIButton).isSelected = false
            }
        }
    }
    @IBAction func menuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())
        
    }
    func doneStartPickerTapped(sender : UIButton) {
        inputViewStart.isHidden = true
        yearLabel.text = yearArr.object(at: yearIndex) as? String
        if yearIndex == currentYearIndex {
            
        }
        else {
            currentYearIndex = yearIndex
            self.currentIndex = 1
            self.searchFilterTapped(UIButton())
        }
        //self.searchFilterTapped(sender)
        
    }
    func doneEndPickerTapped(sender : UIButton) {
        inputViewEnd.isHidden = true
        monthLabel.text = monthArr.object(at: monthIndex) as? String
        //self.searchFilterTapped(sender)
        if monthIndex == currentMonthIndex {
            
        }
        else {
            currentMonthIndex = monthIndex
            self.currentIndex = 1
            self.searchFilterTapped(UIButton())
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func yearButtonTapped(_ sender: Any) {
        
        self.inputViewStart.isHidden = false
        self.inputViewEnd.isHidden = true
        
    }
    @IBAction func monthButtonTapped(_ sender: Any) {
        
        self.inputViewEnd.isHidden = false
        self.inputViewStart.isHidden = true
        
    }
    
    // MARK:- tableview delagate data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bestSellarArr.count == 0 {
            return 1
        }
        if showLoadMore == false {
            return self.bestSellarArr.count
        }
        return 1 + self.bestSellarArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BestSellarTableViewCell
        if bestSellarArr.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "NoRecordsCell") as! BestSellarTableViewCell
            
        }
        if indexPath.row == bestSellarArr.count {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! BestSellarTableViewCell
            return cell
        }
        else {
            
            let dict = self.bestSellarArr.object(at: indexPath.row) as! NSDictionary
            cell.sellarProductName.text = dict.object(forKey: "name") as? String
            let imageUrl = dict.object(forKey: "thumbnail") as? String
            
            cell.sellarImage.sd_setShowActivityIndicatorView(true)
            cell.sellarImage.sd_setIndicatorStyle(.gray)
            cell.sellarImage.sd_setImage(with: URL(string: imageUrl!), completed: nil)
            
            let fontSize = 13
            
            cell.sellarProductName.font = ObjRef.sharedInstance.updateFont(fontName: cell.sellarProductName.font.fontName, fontSize: fontSize)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == bestSellarArr.count && self.showLoadMore == true {
            if dataLoaded == true {
                self.currentIndex += 1
                self.searchFilterTapped(UIView())
            }
            else {
                self.currentIndex += 1
                APIManager.sharedInstance.getRequestWithId(appendParam: "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&limit=10&page=\(currentIndex)", presentingView: self.view,showLoader : true, onSuccess: { (json) in
                    
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
                            if let data = json.object(at: 0) as? NSArray {
                                if data.count == 10 {
                                    self.showLoadMore = true
                                }
                                else {
                                    self.showLoadMore = false
                                }
                                
                                self.productData = json as! NSArray
                                self.bestSellarArr.addObjects(from: data as! [Any])
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.sellarTableView.reloadData()
                                })
                                
                            }
                        }
                    }
                    
                }, onFailure: { (error) in
                    
                    
                })
            }
            
            
            return
        }
        
        let dict = self.bestSellarArr.object(at: indexPath.row) as! NSDictionary
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.productDetail = dict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func downloadImage(url: URL,imageView : UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            print(error?.localizedDescription ?? "Error")
            }.resume()
    }
    
    // MARK:- picker view delegate and data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerMonth {
            return monthArr.count
        }
        return yearArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerMonth {
            return monthArr.object(at: row) as? String
        }
        return yearArr.object(at: row) as? String
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (pickerLabel?.font.fontName)!, fontSize: 17)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        if pickerView == pickerYear {
            pickerLabel?.text = yearArr.object(at: row) as? String
        }
        if pickerView == pickerMonth {
            pickerLabel?.text = monthArr.object(at: row) as? String
        }
        
        return pickerLabel!;
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerMonth {
            monthIndex = row
            
        }
        else {
            yearIndex = row
            
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
