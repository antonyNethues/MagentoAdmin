//
//  CustomerIntViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class CustomerIntViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,SearchFilterDelegate,EditCustomerDelegate {
    
    @IBOutlet var topFilterView: UIView!
    @IBOutlet var tableviewTopConst: NSLayoutConstraint!
    @IBOutlet var userTableView: UITableView!
    @IBOutlet var startDateLab: UILabel!
    @IBOutlet var endDateLab: UILabel!
    var userArr = NSMutableArray()
    var fullUserArr = NSMutableArray()
    
    @IBOutlet var searchButton: UIButton!
    var yearIndex = Int()
    var monthIndex = Int()
    var totalCustomer = Int()
    
    var currentIndex = Int()
    var lastYearCustomer = Int()
    var lastMonthCustomer = Int()
    
    var showLoadMore = Bool()
    var dataLoaded = Bool()
    
    var inputViewStart = UIView()
    var inputViewEnd = UIView()
    var customerData = NSArray()
    var pickerYear = UIPickerView()
    var pickerMonth = UIPickerView()
    
    
    var monthArr = NSMutableArray()
    var yearArr = NSMutableArray()
    var databasePath = String()
    
    var filterValName = String()
    var filterValId = Int()
    var filterValEmail = String()
    
    var backFromSearchFilter = Bool()
    var lastYearBool = Bool()
    var lastMonthBool = Bool()
    
    var currentDataUrl = String()
    var localDBObj = FMDatabase()
    var filterValChanged = Bool()
    
    var firstTimeLoad = Bool()
    
    var doneButton2 = UIButton()
    var doneButton = UIButton()
    var fmdbq : FMDatabaseQueue!
    var tableViewTopOldConst = Int()
    
    func updateCustomerListing() {
        self.reloadTapped(UIButton())
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewTopOldConst = Int(tableviewTopConst.constant)
        tableviewTopConst.constant = 15
        
        self.title = "Customer"
        
        currentIndex = 0
        
        monthArr = ["Select","January","February","March","April","May","June","July","August","September","October","November","December"]
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        var lastMonth = calendar.component(.month, from: date)
        if lastMonth == 1 {
            lastMonth = monthArr.count - 1
        }
        yearArr.add("Select")
        if self.lastMonthBool == true {
            monthIndex = lastMonth
            endDateLab.text = monthArr.object(at: monthIndex) as? String
        }
        else if self.lastYearBool == true {
            yearIndex = 2
            startDateLab.text = "\(year - 1)"
            
        }
        
        for i in 0  ..< 10  {
            let newYear = year - i
            yearArr.add("\(newYear)")
        }
        
        
        //navigation bar right button
        
        let searchImage = UIImage(named: "search2")!
        let clipImage = UIImage(named: "refresh")!
        let pencilImage = UIImage(named: "filter")!
        
        let searchBtn: UIButton = UIButton()
        searchBtn.setImage(searchImage, for: UIControlState.normal)
        searchBtn.addTarget(self, action: #selector(self.searchTapped(_:)), for: UIControlEvents.touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        
        let clipBtn: UIButton = UIButton()
        clipBtn.setImage(clipImage, for: UIControlState.normal)
        clipBtn.addTarget(self, action: #selector(self.reloadTapped(_:)), for: UIControlEvents.touchUpInside)
        clipBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)
        
        let pencilBtn: UIButton = UIButton()
        pencilBtn.setImage(pencilImage, for: UIControlState.normal)
        pencilBtn.addTarget(self, action: #selector(self.filterTapped(_:)), for: UIControlEvents.touchUpInside)
        pencilBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let pencilBarBtn = UIBarButtonItem(customView: pencilBtn)
        
        self.navigationItem.setRightBarButtonItems([clipBarBtn, searchBarBtn, pencilBarBtn], animated: false)
       // self.navigationItem.setLeftBarButtonItems([pencilBarBtn], animated: false)
        
        
        //lab border
        
        startDateLab.layer.borderWidth = 1
        endDateLab.layer.borderWidth = 1
        startDateLab.layer.borderColor = UIColor.lightGray.cgColor
        endDateLab.layer.borderColor = UIColor.lightGray.cgColor

        let fontSize = 13
        
        startDateLab.font = ObjRef.sharedInstance.updateFont(fontName: startDateLab.font.fontName, fontSize: fontSize)
        endDateLab.font = ObjRef.sharedInstance.updateFont(fontName: endDateLab.font.fontName, fontSize: fontSize)
        
        
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
//        let superVc = self.parent?.parent?.parent as? HomeViewController 

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
        
        
        _ = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        
        //self.loadNewDataWithLocalUpdate(sender: UIButton())
        
        localDBObj = MagentoDatabase.sharedInstance.MagentoDB
        
        //var queue = self.getFMDBQueue()
        // queue.inTransaction({ (db, rollback) in
        DispatchQueue.global(qos: .background).sync {
            
            if (self.localDBObj.open()) {
                
                let dropTable = "DELETE FROM CUSTOMER"
                do {
                    try self.localDBObj.executeUpdate(dropTable, withArgumentsIn: [])
                }
                catch {
                    print("Could not create table.")
                    print(error.localizedDescription)
                    print("Error: \(self.localDBObj.lastErrorMessage())")
                }
                
                //localDBObj.close()
                
            }
        }
        
        //})
        
        
        //DispatchQueue.main.asyncAfter(deadline: when) {
        self.loadNewDataWithLocalUpdate(sender: UIButton())
        // }
        
        //http://magentoapp.newsoftdemo.info/adminapp/customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&limit=10&page=1
        // Make a dateFormatter in which format you would like to display the selected date in the textfield.
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    func loadNewDataWithLocalUpdate(sender : UIButton) {
        
        self.dataLoaded = false
        self.currentIndex = 0
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        var lastMonth = calendar.component(.month, from: date)
        if lastMonth == 1 {
            lastMonth = monthArr.count - 1
        }
        var localDbUrl = "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&listing=1&limit=10&page=\(self.currentIndex)"
        
        if self.lastYearBool == true {
            localDbUrl = localDbUrl + "&year=\(year - 1)"
        }
        else if self.lastMonthBool == true {
            localDbUrl = localDbUrl + "&month=\(lastMonth)"
            monthIndex = lastMonth
            pickerMonth.selectRow(monthIndex, inComponent: 0, animated: false)
            endDateLab.text = monthArr.object(at: monthIndex) as? String
            
        }
        
        currentDataUrl = localDbUrl
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            DispatchQueue.main.async(execute: { () -> Void in
                sender.isSelected = false
            })
            
            if let responseData = json as? NSDictionary {
                
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        
                        if let data = responseData.object(forKey: "data") as? NSArray {
                            if data.count == 10 {
                                self.showLoadMore = true
                            }
                            else {
                                self.showLoadMore = false
                            }
                            self.customerData = data as! NSArray
                            self.userArr = NSMutableArray(array: data)
                            self.fullUserArr = self.userArr
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.userTableView.reloadData()
                            })
                        }
                    }
                    else {
                        self.userArr = NSMutableArray()
                        self.userTableView.reloadData()
                        
                        if let message = responseData.object(forKey: "message") as? String {
                            ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                        }
                    }
                }
                
            }
            else {
                
               // if json.count > 0 {
                
                    //self.userDataLoaded()
               // }
            }
            
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            DispatchQueue.main.async(execute: { () -> Void in
                sender.isSelected = false
            })
        })
        
        //database local
        
        
        
        DispatchQueue.global(qos: .background).sync {
            
            if (localDBObj.open()) {
                // let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CUSTOMER (ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, FIRSTNAME TEXT, LASTNAME TEXT, ENTITYID TEXT, EMAIL TEXT, MONTH TEXT, UPDATED TEXT)"
                if !(localDBObj.executeStatements(sql_stmt)) {
                    print("Error: \(localDBObj.lastErrorMessage())")
                }
                // localDBObj.close()
            } else {
                print("Error: \(localDBObj.lastErrorMessage())")
            }
            
            if lastMonthCustomer == 0 && lastMonthBool == true {
                // return
            }
            else if lastYearCustomer == 0 && lastMonthBool == true {
                // return
            }
            
            print("This is run on the background queue")
            
            let localDbUrl = "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&listing=1&limit=\(self.totalCustomer)&page=1"
            
            let date = Date()
            
            
            let calendar = Calendar.current
            
            _ = calendar.component(.year, from: date)
            _ = calendar.component(.month, from: date) - 1
            
            if self.firstTimeLoad == false {
                self.firstTimeLoad = true
                if self.lastYearBool == true {
                    // localDbUrl = localDbUrl + "&year=\(year - 1)"
                }
                else if self.lastMonthBool == true {
                    //localDbUrl = localDbUrl + "&month=\(lastMonth)"
                }
            }
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
                                print("new block")
                                self.customerData = NSArray(object: data)
                                
                                self.userDataLoaded(totalArr: NSArray(object: data))
                            }
                        }
                        else {
                            DispatchQueue.global(qos: .background).sync {
                                print("old block")
                                self.customerData = json as! NSArray
                                
                                self.userDataLoaded(totalArr: self.customerData )
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
        
        //var queue = self.getFMDBQueue()
        //queue.inTransaction({ (db, rollback) in
        
        
        
        if (localDBObj.open()) {
            //(ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, ID TEXT, EMAIL TEXT, MONTH TEXT, YEAR TEXT)
            print("0")
            
            for i in 0  ..< totalArr.count {
                do {
                    
                    let dict = totalArr.object(at: i) as! NSDictionary
                    var firstname = String()
                    var lastname = String()
                    var entity_id = String()
                    var email = String()
                    var created_at = String()
                    var updated_at = String()
                    
                    if let nameF = dict["firstname"] as? String {
                        firstname = nameF
                    }
                    if let nameL = dict["lastname"] as? String {
                        lastname = nameL
                    }
                    if let id = dict["entity_id"] as? String {
                        entity_id = id
                    }
                    
                    if let createdat = dict["created_at"] as? String {
                        created_at = createdat
                    }
                    if let statusV = dict["updated_at"] as? String {
                        updated_at = statusV
                    }
                    if let emailV = dict["email"] as? String {
                        email = emailV
                    }
                    
                    
                    let username = firstname + " "   + lastname
                    
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-mm-dd hh:mm:ss"
                    df.timeZone = TimeZone(identifier: "UTC")
                    _ = df.date(from: created_at)
                    //
                    //                let calendar = Calendar.current
                    //                let month = calendar.component(.month, from: date!)
                    //                let year = calendar.component(.year, from: date!)
                    
                    //let month2 = calendar.component(.month, from: date2!)
                    //let year2 = calendar.component(.year, from: date2!)
                    //                let find = "SELECT * FROM CUSTOMER WHERE entityid like '\(entity_id)'"
                    //                var insertSQL = "UPDATE CUSTOMER set username = '\(username)',firstname = '\(firstname)',lastname = '\(lastname)', entityid = '\(entity_id)', email = '\(email)',month = '\(created_at)',updated = '\(updated_at)' WHERE entityid = '\(entity_id)' "
                    //
                    //                if !(localDBObj.executeStatements(find)) {
                    //                    print("Error: \(localDBObj.lastErrorMessage())")
                    let insertSQL = "INSERT INTO CUSTOMER (username,firstname,lastname, entityid, email,month,updated) VALUES ('\(username)','\(firstname)','\(lastname)', '\(entity_id)', '\(email)', '\(created_at)', '\(updated_at)')"
                    //                    if !(localDBObj.executeStatements(insertSQL)) {
                    //                        print("Error: \(localDBObj.lastErrorMessage())")
                    //                    }
                    //                    else {
                    //                        print("conatct added")
                    //                    }
                    //
                    //                }
                    //                else {
                    // localDBObj.executeStatements(insertSQL)
                    
                    //print("added")
                    try localDBObj.executeStatements(insertSQL)
                    
                    // [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                    
                    //                    if !localDBObj.executeStatements(insertSQL) {
                    //                        print("Failed to insert initial data into the database.")
                    //                        print(localDBObj.lastError(), localDBObj.lastErrorMessage())
                    //                    }
                    //                    else {
                    //                        print("added")
                    //                    }
                }
                catch {
                    print("Could not create table.")
                    print(error.localizedDescription)
                    print("Error: \(localDBObj.lastErrorMessage())")
                    
                }
                
                //                if !(localDBObj.executeStatements(insertSQL)) {
                //                    print("Error: \(localDBObj.lastErrorMessage())")
                //                }
                //                else {
                //                    print("conatct updated")
                //                }
                
                //                }
                
                //
                
            }
            //if totalArr.count > 0 {
            dataLoaded = true
            //}
            //localDBObj.close()
            
            
        } else {
            print("Error: \(localDBObj.lastErrorMessage())")
            dataLoaded = true
            
        }
        //})
        
    }
    func getFMDBQueue() -> FMDatabaseQueue {
        if self.fmdbq == nil {
            self.fmdbq = FMDatabaseQueue(path: MagentoDatabase.sharedInstance.databasePath)
        }
        return self.fmdbq
    }
    
    
    
    
    func doneStartPickerTapped(sender : UIButton) {
        inputViewStart.isHidden = true
        
        startDateLab.text = yearArr.object(at: yearIndex) as? String
        endDateLab.text = monthArr.object(at: monthIndex) as? String
        
        filterValChanged = true
        //        APIManager.sharedInstance.getRequestWithId(appendParam: "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&month=\(endDateLab.text!)&year=\(startDateLab.text!)", presentingView: self.view, onSuccess: { (json) in
        //
        //            if json.count > 0 {
        ////                self.customerData = json as! NSArray
        ////                let arr = self.customerData.object(at: 0) as! NSArray
        ////                self.userArr.add(arr)
        ////                self.userTableView.reloadData()
        //            }
        //
        //        }, onFailure: { (error) in
        //
        //
        //        })
        
    }
    func doneEndPickerTapped(sender : UIButton) {
        inputViewEnd.isHidden = true
        
        startDateLab.text = yearArr.object(at: yearIndex) as? String
        endDateLab.text = monthArr.object(at: monthIndex) as? String
        filterValChanged = true
        
        
        //        APIManager.sharedInstance.getRequestWithId(appendParam: "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&month=\(endDateLab.text)&year=\(startDateLab.text)", presentingView: self.view, onSuccess: { (json) in
        //
        //            if json.count > 0 {
        //                self.customerData = json as! NSArray
        //                self.userArr = self.customerData.object(at: 0) as! NSMutableArray
        //                self.userTableView.reloadData()
        //            }
        //
        //        }, onFailure: { (error) in
        //
        //
        //        })
        
    }
    
    @IBAction func yearPickerTapped(_ sender: Any) {
        
        if (sender as! UIButton).tag == 5 {
            
        }
        else {
            
        }
        self.pickerYear.selectRow(yearIndex, inComponent: 0, animated: false)
        self.pickerMonth.selectRow(monthIndex, inComponent: 0, animated: false)
        
        self.inputViewStart.isHidden = false
        self.inputViewEnd.isHidden = true
        
    }
    
    @IBAction func monthPickerTapped(_ sender: Any) {
        
        if (sender as! UIButton).tag == 5 {
            
        }
        else {
            
        }
        self.inputViewEnd.isHidden = false
        self.inputViewStart.isHidden = true
        
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 1, animations: {
            if self.tableviewTopConst.constant == CGFloat(self.tableViewTopOldConst) {
                self.tableviewTopConst.constant = 15
                self.topFilterView.isHidden = true
            }
            else {
                self.tableviewTopConst.constant = CGFloat(self.tableViewTopOldConst)
                self.topFilterView.isHidden = false
            }        }, completion: nil)
        
        
    }
    
    @IBAction func searchFilterTapped(_ sender: Any) {
        
        if sender is UIButton {
            
            if (sender as! UIButton).isSelected == true {
                return
            }
            (sender as! UIButton).isSelected = true
            
            if filterValChanged == true {
                filterValChanged = false
                self.currentIndex = 0
            }
            else if sender is UIButton {
                //return
            }
            if sender is UIButton {
                self.currentIndex = 0
                self.userArr = NSMutableArray()
                
            }
        }
        
        backFromSearchFilter = false
        var querySQL = "SELECT * FROM CUSTOMER WHERE "
        //SELECT * FROM table WHERE
        var checkAccess = Int()
        checkAccess = 0
        
        
        if filterValEmail.characters.count > 0 {
            querySQL = querySQL + "email Like '%\(filterValEmail)%' AND "
            checkAccess = 1
        }
        if filterValName.characters.count > 0 {
            querySQL = querySQL + "username Like '%\(filterValName)%' AND "
            checkAccess = 1
        }
        if filterValId > 0 {
            querySQL = querySQL + "entityid Like '%\(filterValId)%' AND "
            checkAccess = 1
        }
        if yearIndex > 0 {
            querySQL = querySQL + "month Like '\(startDateLab.text!)%' AND "
            checkAccess = 1
        }
        
        
        if monthIndex > 0 {
            if monthIndex > 9 {
                querySQL = querySQL + "month Like '_____\(monthIndex)%' "
            }
            else {
                querySQL = querySQL + "month Like '_____0\(monthIndex)%' "
            }
        }
        else if checkAccess == 1 {
            let endIndex = querySQL.index(querySQL.endIndex, offsetBy: -4)
            let truncated = querySQL.substring(to: endIndex)
            
            querySQL = truncated
        }
        else if checkAccess == 0 {
            
            querySQL = "SELECT * FROM CUSTOMER "
            
        }
        
        if self.currentIndex == 0 {
            self.userArr = NSMutableArray()
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
                    let dict = [
                        "firstname" : results.string(forColumn: "firstname"),
                        "lastname" : results.string(forColumn: "lastname"),
                        "email" : results.string(forColumn: "email"),
                        "entity_id" : results.string(forColumn: "entityid"),
                        "month" : results.string(forColumn: "month"),
                        "updated" : results.string(forColumn: "updated")
                    ]
                    
                    self.userArr.add(dict)
                }
                
                if counter == 10 {
                    self.showLoadMore = true
                }
                else {
                    self.showLoadMore = false
                }
                self.userTableView.reloadData()
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
    
    @IBAction func searchTapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchUserViewController") as! SearchUserViewController
        vc.nameVal = self.filterValName
        if self.filterValId > 0 {
            vc.idVal = "\(self.filterValId)"
        }
        vc.emailVal = self.filterValEmail
        
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- search filter delgate
    func sendDataOfUser(name: String, id: Int, email: String) {
        
        self.filterValName = name
        self.filterValId = id
        self.filterValEmail = email
        
        filterValChanged = true
        
        backFromSearchFilter = true
        self.searchFilterTapped(UIButton())
    }
    
    @IBAction func reloadTapped(_ sender: UIButton) {
        
        if sender.isSelected == true || self.dataLoaded == false {
            return
        }
        sender.isSelected = true
        
        self.filterValName = ""
        self.filterValId = 0
        self.filterValEmail = ""
        yearIndex = 0
        monthIndex = 0
        
        startDateLab.text = yearArr.object(at: yearIndex) as? String
        endDateLab.text = monthArr.object(at: monthIndex) as? String
        DispatchQueue.global(qos: .background).async {
            
            if (self.localDBObj.open()) {
                
                let dropTable = "DELETE FROM CUSTOMER"
                let result = self.localDBObj.executeUpdate(dropTable, withArgumentsIn: [])
                if !result {
                    print("Error: \(self.localDBObj.lastErrorMessage())")
                }
                // localDBObj.close()
                
            }
        }
        _ = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        // DispatchQueue.main.asyncAfter(deadline: when) {
        self.loadNewDataWithLocalUpdate(sender:sender)
        //}
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //addDatePickerInputViews()
        
        //self.searchButton.layer.cornerRadius = self.searchButton.frame.size.height*0.5
        self.searchButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (self.searchButton.titleLabel?.font.fontName)!, fontSize: 16)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let vc = self.parent?.parent?.parent as? HomeViewController {
            let height = vc.customTabBar.frame.size.height
            
            inputViewEnd.frame = CGRect(x: 0, y: self.view.frame.size.height - 240 - height, width: self.view.frame.width, height: 240)
            pickerMonth.frame = CGRect(x: 0, y: 40, width: view.frame.size.width, height: 200)
            
            inputViewStart.frame = CGRect(x: 0, y: self.view.frame.size.height - 240 - height, width: self.view.frame.width, height: 240)
            pickerYear.frame = CGRect(x: 0, y: 40, width: view.frame.size.width, height: 200)
            
            doneButton.frame = CGRect(x: (self.view.frame.size.width) - (100), y: 0, width: 100, height: 40)
            doneButton2.frame = CGRect(x: (self.view.frame.size.width) - (100), y: 0, width: 100, height: 40)
            
        }
        
        if let vc = self.parent?.parent?.parent as? HomeViewController {
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
            
           // inputViewStart.backgroundColor = UIColor.green
          //  pickerYear.backgroundColor = UIColor.yellow
        }
        
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        //dateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userArr.count == 0 {
            return 1
        }
        tableView.estimatedRowHeight = 125
        tableView.rowHeight = UITableViewAutomaticDimension
        if showLoadMore == false {
            return userArr.count
        }
        return userArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomIntTableViewCell
        if userArr.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "NoRecordsCell") as! CustomIntTableViewCell
        }
        if indexPath.row == userArr.count {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! CustomIntTableViewCell
            
        }
        else {
            let fontSize = 10
            cell.usernameLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.usernameLab.font.fontName, fontSize: fontSize)
            cell.emailLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.emailLab.font.fontName, fontSize: fontSize)
            cell.usernameLab.text = ""
            cell.emailLab.text = ""
            
            cell.deleteButton.tag = indexPath.row + 1
            cell.editButton.tag = indexPath.row + 1
            
            let dictCell = self.userArr.object(at: indexPath.row) as! NSDictionary
            if let email  = dictCell.object(forKey: "email") as? String {
                cell.emailLab.text = email
                
            }
            if let firstname  = dictCell.object(forKey: "firstname") as? String {
                cell.usernameLab.text = firstname
                if let lastname  = dictCell.object(forKey: "lastname") as? String {
                    cell.usernameLab.text = firstname + " " + lastname
                }
                
            }
            
            for obj in cell.contentView.subviews {
                if obj is UILabel {
                    (obj as! UILabel).font = ObjRef.sharedInstance.updateFont(fontName: (obj as! UILabel).font.fontName, fontSize: fontSize)

                }
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == userArr.count && self.showLoadMore == true {
            if dataLoaded == true {
                self.currentIndex += 1
                
                self.searchFilterTapped(UIView())
            }
            else {
                self.currentIndex += 1
                APIManager.sharedInstance.getRequestWithId(appendParam: "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&listing=1&limit=10&page=\(currentIndex)", presentingView: self.view,showLoader : true, onSuccess: { (json) in
                    
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
                            if let data = json as? NSArray {
                                if data.count == 10 {
                                    self.showLoadMore = true
                                }
                                else {
                                    self.showLoadMore = false
                                }
                                
                                
                                self.customerData = json as! NSArray
                                self.userArr.addObjects(from: data as! [Any])
                                self.fullUserArr = self.userArr
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.userTableView.reloadData()
                                })
                            }
                        }
                    }
                    
                }, onFailure: { (error) in
                    
                    
                })
            }
            
            
            return
        }
        let dictCell = self.userArr.object(at: indexPath.row) as! NSDictionary
        let entityId = dictCell["entity_id"] as! String
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailSegue") as! CustomerDetailViewController
        vc.customerId = entityId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func addDatePickerInputViews() {
        inputViewStart = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.width, height: 240))
        inputViewStart.backgroundColor = UIColor.white
        
        let picker : UIDatePicker = UIDatePicker()
        picker.tag = 1
        picker.backgroundColor = UIColor.white
        picker.datePickerMode = UIDatePickerMode.date
        picker.addTarget(self, action: #selector(self.dueDateChanged(sender:)), for: UIControlEvents.valueChanged)
        _ = picker.sizeThatFits(self.view.frame.size)
        picker.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 200)
        picker.minimumDate = Date()
        //you probably don't want to set background color as black
        //picker.backgroundColor = UIColor.blackColor()
        inputViewStart.addSubview(picker)
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width) - (100), y: 0, width: 100, height: 40))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        doneButton.addTarget(self, action: #selector(self.doneStartTapped(sender:)), for: UIControlEvents.touchUpInside)
        inputViewStart.addSubview(doneButton) // add Button to UIView
        
        self.view.addSubview(inputViewStart)
        
        
        //end date picker
        
        inputViewEnd = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - 240, width: self.view.frame.width, height: 240))
        inputViewEnd.backgroundColor = UIColor.white
        
        let picker2 : UIDatePicker = UIDatePicker()
        picker2.tag = 2
        picker2.backgroundColor = UIColor.white
        picker2.datePickerMode = UIDatePickerMode.date
        picker2.addTarget(self, action: #selector(self.dueDateChanged(sender:)), for: UIControlEvents.valueChanged)
        _ = picker2.sizeThatFits(self.view.frame.size)
        picker2.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 200)
        picker2.minimumDate = Date()
        //you probably don't want to set background color as black
        //picker.backgroundColor = UIColor.blackColor()
        inputViewEnd.addSubview(picker2)
        
        let doneButton2 = UIButton(frame: CGRect(x: (self.view.frame.size.width) - (100), y: 0, width: 100, height: 40))
        doneButton2.setTitle("Done", for: UIControlState.normal)
        doneButton2.setTitle("Done", for: UIControlState.highlighted)
        doneButton2.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton2.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        doneButton2.addTarget(self, action: #selector(self.doneEndTapped(sender:)), for: UIControlEvents.touchUpInside)
        inputViewEnd.addSubview(doneButton2) // add Button to UIView
        
        self.view.addSubview(inputViewEnd)
        
        inputViewEnd.isHidden = true
        inputViewStart.isHidden = true
    }
    @IBAction func startingDateButtonAction(_ sender: Any) {
        
        inputViewStart.isHidden = false
    }
    
    @IBAction func endDateButtonAction(_ sender: Any) {
        
        let pickerDate = inputViewStart.viewWithTag(1) as! UIDatePicker
        let pickerDate2 = inputViewEnd.viewWithTag(2) as! UIDatePicker
        pickerDate2.minimumDate = pickerDate.date
        
        inputViewEnd.isHidden = false
    }
    func doneStartTapped(sender : UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd MMM YYYY"
        let pickerDate = inputViewStart.viewWithTag(1) as! UIDatePicker
        
        startDateLab.text = dateFormatter.string(from: pickerDate.date)
        inputViewStart.isHidden = true
    }
    func doneEndTapped(sender : UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd MMM YYYY"
        let pickerDate = inputViewEnd.viewWithTag(2) as! UIDatePicker
        
        endDateLab.text = dateFormatter.string(from: pickerDate.date)
        
        inputViewEnd.isHidden = true
    }
    func dueDateChanged(sender:UIDatePicker){
    }
    @IBAction func editProductTappedFromCell(button : UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditCustomer") as! EditCustomerViewController
        //vc.parentCatArr = self.categoryArr
        vc.editBool = true
        let dictParent = self.userArr.object(at: button.tag - 1) as! NSDictionary
        vc.productData = dictParent
        //vc.catId = dictParent.object(forKey: "category_id") as! String
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func deleteProductTappedFromCell(button : UIButton) {
        
        let alertCont = UIAlertController(title: "", message: "Do you want to delete this customer", preferredStyle: UIAlertControllerStyle.alert)
        alertCont.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            self.deleteConfirm(button: button)
        }))
        alertCont.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alertCont, animated: true, completion: nil)

        
        
        
        
    }

    func deleteConfirm(button : UIButton) {
        
        let dictParent = self.userArr.object(at: button.tag - 1) as! NSDictionary
        let catId = dictParent.object(forKey: "entity_id") as! String
        
        let localDbUrl = "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let dataPost = "delete_customer_id=\(catId)"
        
        APIManager.sharedInstance.postRequestWithId(appendParam: localDbUrl, bodyData: dataPost, presentingView: self.view, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                        if let status = responseData.object(forKey: "status") as? String {
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                if status == "success" {
                                    if let message = responseData.object(forKey: "message") as? String {
                                        let alertCont = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                        alertCont.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                                            self.reloadTapped(UIButton())
                                        }))
                                        self.present(alertCont, animated: true, completion: nil)
                                    }
                                    
                                }
                                else {
                                    if let message = responseData.object(forKey: "message") as? String {
                                        let alertCont = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                        alertCont.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                                            self.reloadTapped(UIButton())
                                        }))
                                        self.present(alertCont, animated: true, completion: nil)
                                    }
                                    
                                }
                            })
                        }
            }
            else {
                
                
            }
            
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            
        })
    }
    //MARK:- uipicker delegate data source
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerYear {
            return yearArr.count
        }
        if pickerView == pickerMonth {
            return monthArr.count
        }
        return 10
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerYear {
            return yearArr.object(at: row) as? String
        }
        if pickerView == pickerMonth {
            return monthArr.object(at: row) as? String
        }
        return ""
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerYear {
            yearIndex = row
        }
        if pickerView == pickerMonth {
            monthIndex = row
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
