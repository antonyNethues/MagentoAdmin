//
//  OrderViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SearchOrderFilterDelegate,UIDocumentInteractionControllerDelegate {
    
    
    enum orderType: String {
        case all = "all",
        shipped = "processing",
        cancelled = "canceled",
        pending = "pending"
        
        static let allValues = [all, shipped, cancelled,pending]
    }
    
    @IBOutlet var cancelledTab: UIButton!
    @IBOutlet var shippedTab: UIButton!
    @IBOutlet var pendingTab: UIButton!
    @IBOutlet var allTab: UIButton!
    
    var currentOrderType = String()
    
    var ordersArr = NSMutableArray()
    var pendingArr = NSMutableArray()
    var shippedArr = NSMutableArray()
    var cancelledArr = NSMutableArray()
    var databasePath = String()
    
    var orderData = NSArray()
    var fullOrderArr = NSMutableArray()
    
    var totalOrders = Int()
    var localDBObj = FMDatabase()
    
    
    var currentIndex = Int()
    var showLoadMore = Bool()
    var dataLoaded = Bool()
    
    var filterValName = String()
    var filterValId = Int()
    var filterValStartTime = String()
    var filterValEndTime = String()
    var filterValEmail = String()
    var activeTab = UIButton()
    
    @IBOutlet var orderTableView: UITableView!
    @IBAction func menuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Order"
        ordersArr = []
        self.currentIndex = 0
        currentOrderType = orderType.all.rawValue
        
        let fontSize = 11
        
        self.allTab.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (self.allTab.titleLabel?.font.fontName)!, fontSize: fontSize)
        self.pendingTab.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (self.pendingTab.titleLabel?.font.fontName)!, fontSize: fontSize)
        self.shippedTab.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (self.shippedTab.titleLabel?.font.fontName)!, fontSize: fontSize)
        self.cancelledTab.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (self.cancelledTab.titleLabel?.font.fontName)!, fontSize: fontSize)
        
        
        self.allTab.backgroundColor = ObjRef.sharedInstance.magentoOrange
        self.shippedTab.backgroundColor = ObjRef.sharedInstance.magentoOrange
        self.cancelledTab.backgroundColor = ObjRef.sharedInstance.magentoOrange
        self.pendingTab.backgroundColor = ObjRef.sharedInstance.magentoOrange
        // Do any additional setup after loading the view.
        
        //navigation bar right button
        
        let searchImage = UIImage(named: "search2")!
        let clipImage = UIImage(named: "refresh")!
        let pencilImage = UIImage(named: "menu")!
        
        let searchBtn: UIButton = UIButton()
        searchBtn.setImage(searchImage, for: UIControlState.normal)
        searchBtn.addTarget(self, action: #selector(self.searchFilterTapped), for: UIControlEvents.touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        
        let clipBtn: UIButton = UIButton()
        clipBtn.setImage(clipImage, for: UIControlState.normal)
        clipBtn.addTarget(self, action: #selector(self.reloadTapped(sender:)), for: UIControlEvents.touchUpInside)
        clipBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)
        
        let pencilBtn: UIButton = UIButton()
        pencilBtn.setImage(pencilImage, for: UIControlState.normal)
        pencilBtn.addTarget(self, action: #selector(self.menuTapped(_:)), for: UIControlEvents.touchUpInside)
        pencilBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        _ = UIBarButtonItem(customView: pencilBtn)
        
        self.navigationItem.setRightBarButtonItems([clipBarBtn, searchBarBtn], animated: false)
        //self.navigationItem.setLeftBarButtonItems([pencilBarBtn], animated: false)

        localDBObj = MagentoDatabase.sharedInstance.MagentoDB
        DispatchQueue.global(qos: .background).sync {
            
            if (self.localDBObj.open()) {
                
                let dropTable = "DELETE FROM ORDERS"
                let result = self.localDBObj.executeUpdate(dropTable, withArgumentsIn: [])
                if !result {
                    print("Error: \(self.localDBObj.lastErrorMessage())")
                }
                //localDBObj.close()
                
            }
        }
        _ = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        //DispatchQueue.main.asyncAfter(deadline: when) {
        self.reloadOrderData(sender: UIButton())
            //}
        
        
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.updateTabSelectedView(buttonTap: activeTab)
        
    }
    func reloadOrderData(sender:UIButton) {
        
        self.currentIndex = 0
        //order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&listing=1&limit=\(self.totalOrders)&page=\(self.currentIndex)
        let localDbUrl = "order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&listing=1&limit=10&page=\(self.currentIndex)"
        
        //        if self.lastYearBool == true {
        //            localDbUrl = localDbUrl + "&year=\(year)"
        //        }
        //        else if self.lastMonthBool == true {
        //            localDbUrl = localDbUrl + "&month=\(lastMonth)"
        //        }
        
        //currentDataUrl = localDbUrl
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        
                        if let data = responseData.object(forKey: "data") as? NSArray {
                            
                            
                            
                            
                                        
                                        self.orderData = data
                                        self.ordersArr = NSMutableArray(array: data as! NSArray)
                                        self.fullOrderArr = self.ordersArr
                                        if self.ordersArr.count == 10 {
                                            self.showLoadMore = true
                                        }
                                        else {
                                            self.showLoadMore = false
                                        }
                                        
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            self.updateTabSelectedView(buttonTap: self.allTab)
                                            
                                            self.orderTableView.reloadData()
                                        })
                            //self.userDataLoaded()
                        }
                    }
                    else {
                        if let message = responseData.object(forKey: "message") as? String {
                            ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                            DispatchQueue.main.async(execute: { () -> Void in
                                sender.isSelected = false
                            })
                            
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            sender.isSelected = false
                        })
                        
                    }
                }
                else {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        sender.isSelected = false
                    })
                }
            }
            else {
                DispatchQueue.main.async(execute: { () -> Void in
                    sender.isSelected = false
                })
       
            }
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            DispatchQueue.main.async(execute: { () -> Void in
                sender.isSelected = false
            })
        })
        
        
        //database local
        
        //        if (localDBObj.open()) {
        //
        //            let dropTable = "DROP TABLE ORDERS"
        //            let result = localDBObj.executeUpdate(dropTable, withArgumentsIn: [])
        //            if !result {
        //                print("Error: \(localDBObj.lastErrorMessage())")
        //            }
        //            localDBObj.close()
        //
        //        }
        
        
        DispatchQueue.global(qos: .background).sync {
            
            if (localDBObj.open()) {
                // let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                let sql_stmt = "CREATE TABLE IF NOT EXISTS ORDERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, FIRSTNAME TEXT, LASTNAME TEXT, EMAIL TEXT, ENTITYID TEXT, TOTAL TEXT, CREATED TEXT, STATUS TEXT, INCREMENTID TEXT, TIMESTAMP INT)"
                if !(localDBObj.executeStatements(sql_stmt)) {
                    print("Error: \(localDBObj.lastErrorMessage())")
                }
                // localDBObj.close()
            } else {
                print("Error: \(localDBObj.lastErrorMessage())")
            }

            self.dataLoaded = false
            
            print("This is run on the background queue")
            
            let localDbUrl = "order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&listing=1"//&limit=\(self.totalOrders)&page=\(self.currentIndex)
            
            APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : false, onSuccess: { (json) in
                
                if let responseData = json as? NSDictionary {
                    if let active = responseData.object(forKey: "status") as? String {
                        if active == "success" {
                            if let data = responseData.object(forKey: "data") as? NSArray {
                                DispatchQueue.global(qos: .background).sync {
                                    self.orderData = data
                                    
                                    self.userDataLoaded(totalArr: data)
                                }
                            }
                            self.dataLoaded = true
//                            if let message = responseData.object(forKey: "message") as? String {
//                                ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
//                            }
                            
                        }
                        else {
                            self.dataLoaded = true
                        }
                    }
                    else {
                    }
                }
                else {
                    
                }
                
            }, onFailure: { (error) in
                print("Error2: \(error.localizedDescription)")
                self.dataLoaded = true
                
            })
            
            
        }
        
    }
    func updateTabSelectedView(buttonTap : UIButton) {
        
        activeTab = buttonTap
        
        self.allTab.frame.size.height = (self.allTab.superview?.frame.size.height)!
        self.shippedTab.frame.size.height = (self.allTab.superview?.frame.size.height)!
        self.pendingTab.frame.size.height = (self.allTab.superview?.frame.size.height)!
        self.cancelledTab.frame.size.height = (self.allTab.superview?.frame.size.height)!
        
        buttonTap.frame.size.height = (self.allTab.superview?.frame.size.height)! - 2
        
    }
    @IBAction func allOrderTapped(sender : UIButton) {
        self.updateTabSelectedView(buttonTap: sender)
        
        self.currentIndex = 0
        self.orderWithFilter(type: orderType.all)
    }
    @IBAction func shippingOrderTapped(sender : UIButton) {
        self.updateTabSelectedView(buttonTap: sender)
        
        self.currentIndex = 0
        self.orderWithFilter(type: orderType.shipped)
    }
    @IBAction func cancelledOrderTapped(sender : UIButton) {
        self.updateTabSelectedView(buttonTap: sender)
        
        self.currentIndex = 0
        self.orderWithFilter(type: orderType.cancelled)
    }
    @IBAction func pendingOrderTapped(sender : UIButton) {
        self.updateTabSelectedView(buttonTap: sender)
        
        self.currentIndex = 0
        self.orderWithFilter(type: orderType.pending)
    }
    
    func orderWithFilter(type : orderType) {
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.orderTableView.setContentOffset(CGPoint.zero, animated: true)
        })
        currentOrderType = type.rawValue
        
        var querySQL = "SELECT * FROM ORDERS WHERE status = '\(type.rawValue)' "
        if type.rawValue == "all" {
            querySQL = "SELECT * FROM ORDERS "
        }
        querySQL = querySQL + "LIMIT 10 OFFSET 0"
        
        if (self.localDBObj.open()) {
            // let querySQL = "SELECT * FROM MAGENTO WHERE username Like '%Jane%',month Like '_____07%' , year '2017%'"
            //let querySQL = "SELECT * FROM MAGENTO WHERE month Like '_____09%' AND year Like '2017%'"
            //let querySQL = "SELECT * FROM MAGENTO"
            
            do {
                let results = try self.localDBObj.executeQuery(querySQL, values: [])
                self.ordersArr = NSMutableArray()
                
                var counter = Int()
                while results.next() == true {
                    counter += 1
                    // print(results.string(forColumn: "username")!)
                    //print(results.resultDictionary!)
                    let dict = [
                        "customer_firstname" : results.string(forColumn: "firstname"),
                        "customer_lastname" : results.string(forColumn: "lastname"),
                        "entity_id" : results.string(forColumn: "entityid"),
                        "created_at" : results.string(forColumn: "created"),
                        "grand_total" : results.string(forColumn: "total"),
                        "increment_id" : results.string(forColumn: "incrementid")
                    ]
                    
                    self.ordersArr.add(dict)
                }
                if counter == 10 {
                    showLoadMore = true
                }
                else {
                    showLoadMore = false
                }
                self.orderTableView.reloadData()
                //                address.text = results?.string(forColumn: "address")
                //                phone.text = results?.string(forColumn: "phone")
                //                status.text = "Record Found"
                results.close()
            }
            catch {
                print("error\(error.localizedDescription)")
            }
            //           // let results:FMResultSet? = contactDB.executeQuery(querySQL,
            //                                                               withArgumentsIn: [])
            
            do {
                //self.localDBObj.close()
            }
            catch {
                
            }
        } else {
            print("Error: \(self.localDBObj.lastErrorMessage())")
        }
    }
    func userDataLoaded(totalArr : NSArray) {
        //database local
        
        
        if (localDBObj.open()) {
            //(ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, ID TEXT, EMAIL TEXT, MONTH TEXT, YEAR TEXT)
            for i in 0  ..< totalArr.count {
                let dict = totalArr.object(at: i) as! NSDictionary
                var firstname = String()
                var lastname = String()
                var entity_id = String()
                var increment_id = String()
                var grand_total = String()
                var created_at = String()
                var status = String()
                var email = String()
                
                if let nameF = dict["customer_firstname"] as? String {
                    firstname = nameF
                }
                if let nameL = dict["customer_lastname"] as? String {
                    lastname = nameL
                }
                if let id = dict["entity_id"] as? String {
                    entity_id = id
                }
                if let incrementId = dict["increment_id"] as? String {
                    increment_id = incrementId
                }
                if let grandtotal = dict["grand_total"] as? String {
                    grand_total = grandtotal
                }
                if let createdat = dict["created_at"] as? String {
                    created_at = createdat
                }
                if let statusV = dict["status"] as? String {
                    status = statusV
                }
                if let emailV = dict["email"] as? String {
                    email = emailV
                }
                
                
                let username = firstname + " "   + lastname
                
                let df = DateFormatter()
                df.dateFormat = "yyyy-mm-dd hh:mm:ss"
                _ = df.date(from: created_at)
                let timestamp = Int()
                
                
                //
                //                let calendar = Calendar.current
                //                let month = calendar.component(.month, from: date!)
                //                let year = calendar.component(.year, from: date!)
                
                //let month2 = calendar.component(.month, from: date2!)
                //let year2 = calendar.component(.year, from: date2!)
                
                let insertSQL = "INSERT INTO ORDERS (username,firstname,lastname,email , entityid, total,created,status,incrementid,timestamp) VALUES ('\(username)','\(firstname)','\(lastname)','\(email)', '\(entity_id)', '\(grand_total)', '\(created_at)', '\(status)', '\(increment_id)', '\(timestamp)')"
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
            dataLoaded = true
            
            //localDBObj.close()
            
            
        } else {
            dataLoaded = true
            
            print("Error: \(localDBObj.lastErrorMessage())")
        }
        
    }
    
    @IBAction func allOrderTapped(_ sender: Any) {
        
    }
    
    func searchFilterTappedFromFilterScreen(_ sender: Any) {
        
        if sender is UIButton {
            self.currentIndex = 0
            self.ordersArr = NSMutableArray()
            
        }
        var querySQL = "SELECT * FROM ORDERS WHERE status = '\(currentOrderType)' AND "
        if currentOrderType == "all" {
            querySQL = "SELECT * FROM ORDERS WHERE "
        }
        
        var checkAccess = Int()
        checkAccess = 0
        
        
        if filterValName.characters.count > 0 {
            querySQL = querySQL + "username Like '%\(filterValName)%' AND "
            checkAccess = 1
        }
        if filterValEmail.characters.count > 0 {
            querySQL = querySQL + "email Like '%\(filterValEmail)%' AND "
            checkAccess = 1
        }
        if filterValId > 0 {
            querySQL = querySQL + "entityid Like '%\(filterValId)%' AND "
            checkAccess = 1
        }
        if filterValStartTime != "" && filterValEndTime != "" {
            querySQL = querySQL + "CREATED between Datetime('" + filterValStartTime + " 00:00:00"  + "') and Datetime('" + filterValEndTime + " 12:00:00" + "') AND "
            checkAccess = 1
            
        }
        if checkAccess == 1 {
            let endIndex = querySQL.index(querySQL.endIndex, offsetBy: -4)
            let truncated = querySQL.substring(to: endIndex)
            
            querySQL = truncated
        }
        else if checkAccess == 0 {
            //self.userArr = self.fullUserArr
            //            DispatchQueue.main.async(execute: { () -> Void in
            //                self.userTableView.reloadData()
            //            })
            querySQL = "SELECT * FROM ORDERS WHERE status = '\(currentOrderType)' "
            if currentOrderType == "all" {
                querySQL = "SELECT * FROM ORDERS "
            }
            
            //self.currentIndex = 1
            //return
        }
        
        if self.currentIndex == 0 {
            self.ordersArr = NSMutableArray()
        }
        querySQL = querySQL + "LIMIT 10 OFFSET \(self.currentIndex*10)"
        //SELECT * FROM ORDERS WHERE FIRSTNAME LIke "j%" AND CREATED between Datetime('2011-01-29 12:00:00') and Datetime('2013-12-29 12:00:00') LIMIT 10 OFFSET 0
        
        if (self.localDBObj.open()) {
            // let querySQL = "SELECT * FROM MAGENTO WHERE username Like '%Jane%',month Like '_____07%' , year '2017%'"
            //let querySQL = "SELECT * FROM MAGENTO WHERE month Like '_____09%' AND year Like '2017%'"
            //let querySQL = "SELECT * FROM MAGENTO"
            
            do {
                let results = try self.localDBObj.executeQuery(querySQL, values: [])
                //self.ordersArr = NSMutableArray()
                var counter = Int()
                counter = 0
                while results.next() == true {
                    // print(results.string(forColumn: "username")!)
                    //print(results.resultDictionary!)
                    counter += 1
                    /*
                     let dict = totalArr.object(at: i) as! NSDictionary
                     let firstname = dict["customer_firstname"] as! String
                     let lastname = dict["customer_lastname"] as! String
                     let username = firstname + " "   + lastname
                     let entity_id = dict["entity_id"] as! String
                     let increment_id = dict["increment_id"] as! String
                     let grand_total = dict["grand_total"] as! String
                     let created_at = dict["created_at"] as! String
                     let status = dict["status"] as! String
                     let email = dict["customer_email"] as! String
                     */
                    let dict = [
                        "customer_firstname" : results.string(forColumn: "firstname"),
                        "customer_lastname" : results.string(forColumn: "lastname"),
                        "entity_id" : results.string(forColumn: "entityid"),
                        "created_at" : results.string(forColumn: "created"),
                        "grand_total" : results.string(forColumn: "total"),
                        "increment_id" : results.string(forColumn: "incrementid")
                    ]
                    
                    self.ordersArr.add(dict)
                }
                if counter == 10 {
                    self.showLoadMore = true
                }
                else {
                    self.showLoadMore = false
                }
                
                self.orderTableView.reloadData()
                //                address.text = results?.string(forColumn: "address")
                //                phone.text = results?.string(forColumn: "phone")
                //                status.text = "Record Found"
                results.close()
            }
            catch {
                print("error\(error.localizedDescription)")
            }
            //           // let results:FMResultSet? = contactDB.executeQuery(querySQL,
            //                                                               withArgumentsIn: [])
            
            
            //self.localDBObj.close()
        } else {
            print("Error: \(self.localDBObj.lastErrorMessage())")
        }
    }
    
    func sendDataOfOrder(name: String, id: Int, email: String, fromDate: String, toDate: String) {
        
        self.filterValName = name
        self.filterValId = id
        self.filterValStartTime = fromDate
        self.filterValEndTime = toDate
        self.filterValEmail = email
        
        self.searchFilterTappedFromFilterScreen(UIButton())
    }
    
    func searchFilterTapped() {
        
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.filterTapped(self)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
//        vc.delegate = self
//        vc.filterValName = filterValName
//        vc.filterValId = filterValId
//        vc.filterValStartTime = filterValStartTime
//        vc.filterValEndTime = filterValEndTime
//        vc.filterValEmail = filterValEmail
//
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadTapped(sender:UIButton) {
        
        if sender.isSelected == true || self.dataLoaded == false {
            return
        }
        sender.isSelected = true
        
        filterValName = ""
        filterValId = 0
        filterValStartTime = ""
        filterValEndTime = ""
        filterValEmail = ""
        DispatchQueue.global(qos: .background).sync {

        if (self.localDBObj.open()) {
            
            let dropTable = "DELETE FROM ORDERS"
            let result = self.localDBObj.executeUpdate(dropTable, withArgumentsIn: [])
            if !result {
                print("Error: \(self.localDBObj.lastErrorMessage())")
            }
            //localDBObj.close()
            
        }
        }
        _ = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        //DispatchQueue.main.asyncAfter(deadline: when) {
            self.reloadOrderData(sender: sender)
        //}
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ordersArr.count == 0 {
            return 1
        }//NoRecordsCell
        if showLoadMore == false {
            return ordersArr.count
        }
        
        return ordersArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OrderTableViewCell
        if ordersArr.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "NoRecordsCell") as! OrderTableViewCell
        }//
        if indexPath.row == ordersArr.count {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! OrderTableViewCell
            
        }
        else {
            
            let fontSize = 13
            
            cell.orderIdLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderIdLab.font.fontName, fontSize: fontSize)
            cell.orderIdVal.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderIdVal.font.fontName, fontSize: fontSize)
            cell.customerLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.customerLab.font.fontName, fontSize: fontSize)
            cell.customerVal.font = ObjRef.sharedInstance.updateFont(fontName: cell.customerVal.font.fontName, fontSize: fontSize)
            cell.amountLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.amountLab.font.fontName, fontSize: fontSize)
            cell.amountVal.font = ObjRef.sharedInstance.updateFont(fontName: cell.amountVal.font.fontName, fontSize: fontSize)
            cell.dateLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.dateLab.font.fontName, fontSize: fontSize)
            cell.dateVal.font = ObjRef.sharedInstance.updateFont(fontName: cell.dateVal.font.fontName, fontSize: fontSize)
           // cell.dateVal.adjustsFontSizeToFitWidth = true
            
            let dictCell = self.ordersArr.object(at: indexPath.row) as! NSDictionary
            
            if let entity_id  = dictCell.object(forKey: "entity_id") as? String {
                cell.orderIdVal.text = "\(entity_id)"
            }
            if let grand_total  = dictCell.object(forKey: "grand_total") as? String {
                cell.amountVal.text = "\(grand_total)"
            }
            if let created_at  = dictCell.object(forKey: "created_at") as? String {
                cell.dateVal.text = created_at
            }
            if let customer_firstname  = dictCell.object(forKey: "customer_firstname") as? String {
                cell.customerVal.text = customer_firstname
                if let customer_lastname  = dictCell.object(forKey: "customer_lastname") as? String {
                    cell.customerVal.text = customer_firstname + " " + customer_lastname
                }
                
            }
            cell.downloadButton.isHidden = true

            if let invoices = dictCell["Invoices"] as? NSArray {
                if invoices.count > 0 {
                    cell.downloadButton.isHidden = false
                }
            }
            cell.downloadButton.tag = indexPath.row
        }
       // cell.downloadButton.tag = indexPath.row + 1
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == ordersArr.count {
            if dataLoaded == true {
                self.currentIndex += 1
                
                self.searchFilterTappedFromFilterScreen(UIView())
            }
            else {
                self.currentIndex += 1
                
                APIManager.sharedInstance.getRequestWithId(appendParam: "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&listing=1&limit=10&page=\(self.currentIndex)", presentingView: self.view,showLoader : true, onSuccess: { (json) in
                    
                    if let responseData = json as? NSDictionary {
                        if let active = responseData.object(forKey: "status") as? String {
                            if active == "success" {
                                if let data = responseData.object(forKey: "data") as? NSArray {
                                    self.orderData = data
                                    self.ordersArr.addObjects(from: (data) as! [Any])
                                    self.fullOrderArr = self.ordersArr
                                    
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        self.orderTableView.reloadData()
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
                    
                    
                })
                
            }
            return
        }
        
        let dictCell = self.ordersArr.object(at: indexPath.row) as! NSDictionary
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailSegue") as! OrderDetailViewController
        if let increment_id  = dictCell.object(forKey: "increment_id") as? String {
            vc.orderId = increment_id
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == ordersArr.count {
            return 58
        }
        else {
            return 150
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        _ = ordersArr.count - 1
        //        if !loadingData && indexPath.row == lastElement {
        //            indicator.startAnimating()
        //            loadingData = true
        //            loadMoreData()
        //        }
    }
    @IBAction func downloadTapped(_ sender: Any) {
        
        let button = sender as! UIButton
        let dictCell = self.ordersArr.object(at: button.tag) as! NSDictionary
        var invoiceId = String()
        
        if let invoices = dictCell["Invoices"] as? NSArray {
            if invoices.count > 0 {
                invoiceId = (invoices.firstObject as? String)!
            }
        }
        let localDbUrl = "order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&invoice_id=\(invoiceId)"

        APIManager.sharedInstance.getRequestWithIdForPdf(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
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
                
                var docURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
                
                docURL = docURL?.appendingPathComponent(invoiceId + ".pdf")
                
                //Lastly, write your file to the disk.
                do {
                    let writeFile = try (json as! Data).write(to: docURL!)
                    self.loadPDF(filename: invoiceId + ".pdf")
                }
                catch  {
                    
                }
            }
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            
        })
    }
    
    func loadPDF (filename: String)  {
        var documentController = UIDocumentInteractionController()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let filePath = "\(documentsPath)/\(filename)"
        let url = NSURL(fileURLWithPath: filePath)
        documentController = UIDocumentInteractionController(url: url as URL)
        
        documentController.delegate = self as? UIDocumentInteractionControllerDelegate
        
        documentController.presentPreview(animated: true)
        
        
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
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
