//
//  ProductViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 28/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

class ProductViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,EditCategoryDelegate,UITextFieldDelegate {
    
    @IBOutlet var tableViewTopConst: NSLayoutConstraint!
    var tableViewTopOldConst = Int()

    @IBOutlet var searchTextF: UITextField!
    @IBOutlet var topFilterView: UIView!
    var boolVal = Int()
    var fromEditProduct = Bool()
    var fromEditProductCatArr = NSMutableArray()
    
    var currentIndex = Int()
    var currentCatIndex = Int()
    var showLoadMore = Bool()
    var dataLoaded = Bool()
    var customerData = NSDictionary()
    var filterValName = String()
    var firstTimeLoad = Bool()
    var categoryArr = NSMutableArray()
    var fullUserArr = NSMutableArray()
    var localDBObj = FMDatabase()
    var filterValChanged = Bool()
    var idSelectedArr = NSMutableArray()
    
    @IBOutlet var userTableView: UITableView!

    var categoryData = NSDictionary()
    var parentCategoryData = NSDictionary()
    var SelectedCategoryData = NSDictionary()
    var indexCategoryData = NSMutableDictionary()
    var parentCatArr = NSArray()
    var pencilBarBtn = UIBarButtonItem()

    @IBAction func MenuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())
    }
    func updateCategoryListing() {
        self.reloadTapped(UIButton())
    }
    @IBAction func selectButtonTapped(_ sender: Any) {
        let button = sender as! UIButton
        let dictCell = self.categoryArr.object(at: button.tag) as? NSDictionary
        let catId = dictCell?.object(forKey: "category_id") as! String
        
        if idSelectedArr.count > 0 {
            var boolCheck = Bool()
            
            for i in 0  ..< idSelectedArr.count  {
                let obj = self.idSelectedArr.object(at: i) as! String
                if catId == obj {
                    button.isSelected = false
                    idSelectedArr.removeObject(at: i)
                    boolCheck = true
                    break
                }
                else {
                    boolCheck = false
                    
                }
            }
            if boolCheck == false {
                idSelectedArr.add(catId)
                button.isSelected = true
            }
            
        }
        else {
            idSelectedArr.add(catId)
            button.isSelected = true
            
        }

        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableViewTopOldConst = Int(tableViewTopConst.constant)
        tableViewTopConst.constant = 20
        
        currentCatIndex = 0
        
        //navigation bar right button
        
        let searchImage = UIImage(named: "add")!
        let clipImage = UIImage(named: "refresh")!
        let pencilImage = UIImage(named: "menu")!
        let filterImage = UIImage(named: "filter")!

        let searchBtn: UIButton = UIButton()
        searchBtn.setImage(searchImage, for: UIControlState.normal)
        searchBtn.addTarget(self, action: #selector(self.addTapped), for: UIControlEvents.touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        
        let clipBtn: UIButton = UIButton()
        clipBtn.setImage(clipImage, for: UIControlState.normal)
        clipBtn.addTarget(self, action: #selector(self.reloadTapped(_:)), for: UIControlEvents.touchUpInside)
        clipBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)
        
        let pencilBtn: UIButton = UIButton()
        pencilBtn.setImage(pencilImage, for: UIControlState.normal)
        pencilBtn.addTarget(self, action: #selector(self.menuTapped(_:)), for: UIControlEvents.touchUpInside)
        pencilBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        pencilBarBtn = UIBarButtonItem(customView: pencilBtn)
        
        let filterBtn: UIButton = UIButton()
        filterBtn.setImage(filterImage, for: UIControlState.normal)
        filterBtn.addTarget(self, action: #selector(self.filterTapped(_:)), for: UIControlEvents.touchUpInside)
        filterBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let filterBarBtn = UIBarButtonItem(customView: filterBtn)
        
        let doneBut: UIButton = UIButton()
        doneBut.setTitle("Done", for: UIControlState.normal)
        doneBut.titleLabel?.textAlignment = NSTextAlignment.right
        doneBut.addTarget(self, action: #selector(self.doneButton), for: UIControlEvents.touchUpInside)
        doneBut.frame = CGRect(x: 0, y: 0, width: 75, height: 30)
        let doneBarBut = UIBarButtonItem(customView: doneBut)
        
       // self.navigationItem.setRightBarButtonItems([pencilBarBtn,clipBarBtn, searchBarBtn], animated: false)
        if self.fromEditProduct == true {
            
            idSelectedArr = self.fromEditProductCatArr

            self.navigationItem.setRightBarButtonItems([doneBarBut], animated: false)
           // self.navigationItem.setLeftBarButtonItems([], animated: false)

        }
        else {
            
            self.navigationItem.setRightBarButtonItems([clipBarBtn,filterBarBtn], animated: false)
            self.navigationItem.setLeftBarButtonItems([pencilBarBtn], animated: false)
            
        }
        categoryData = ["page" : ["page":["page":"page",
                                          
            "data":["data1","data1","data1","data1"]],
                                  
            "data":["data1","data1","data1","data1"]],
                        "data":["data1","data1","data1","data1"]]
        
        reloadTapped(UIButton())
        // Do any additional setup after loading the view.
        
        let textAttributes = [NSForegroundColorAttributeName:ObjRef.sharedInstance.magentoOrange]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    @IBAction func filterTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 1, animations: {
            if self.tableViewTopConst.constant == CGFloat(self.tableViewTopOldConst) {
                self.tableViewTopConst.constant = 20
                self.topFilterView.isHidden = true
            }
            else {
                self.tableViewTopConst.constant = CGFloat(self.tableViewTopOldConst)
                self.topFilterView.isHidden = false
            }        }, completion: nil)
        
        
    }
    func doneButton() {
        if (self.navigationController?.viewControllers.count)! > 1 {
            if let vc = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? EditProductViewController {
                self.fromEditProductCatArr = idSelectedArr
                vc.catArr = self.fromEditProductCatArr
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    func addTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditCategory") as! EditCategoryViewController
        
      //  vc.parentCatArr = self.categoryArr
        let dictParent = self.SelectedCategoryData
        vc.parentCategoryData = dictParent
        vc.catName = (dictParent.object(forKey: "name") as? String)!

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())
        
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchUserViewController") as! SearchUserViewController
//        vc.nameVal = self.filterValName
//        if self.filterValId > 0 {
//            vc.idVal = "\(self.filterValId)"
//        }
//        vc.emailVal = self.filterValEmail
//        
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    @IBAction func reloadTapped(_ sender: Any) {
        
        self.loadNewDataWithLocalUpdate()
        
    }
    func loadNewDataWithLocalUpdate() {
        
        self.dataLoaded = false
        self.currentIndex = 1
        let date = Date()
        let calendar = Calendar.current
        
        _ = calendar.component(.year, from: date)
        _ = calendar.component(.month, from: date) - 1
        
        let localDbUrl = "category/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        
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
                    if let defCat = responseData["children"] as? NSArray {
                        self.categoryArr = NSMutableArray(array: defCat)
                        self.parentCategoryData = responseData
                        self.indexCategoryData = NSMutableDictionary()
                        self.currentCatIndex = 0
                        self.categoryData = responseData
                        self.indexCategoryData.addEntries(from: [self.currentCatIndex : self.parentCategoryData])
                        self.SelectedCategoryData = self.parentCategoryData
                        //                        if let dict = defCat[0] as? NSDictionary {
                        //                            self.SelectedCategoryData = self.categoryData
//                            self.indexCategoryData.addEntries(from: [self.currentCatIndex : self.SelectedCategoryData])
//
//                            if let children = self.categoryData["children"] as? NSArray {
//                                self.categoryArr = NSMutableArray(array: children)
//                            }
//                        }
                    }
                    //self.userArr = NSMutableArray(array: data)
                    //self.fullUserArr = self.userArr
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.userTableView.reloadData()
                    })
                    
                    //                if json.count > 0 {
                    //                    if json is NSNull {
                    //
                    //                    }
                    //                    else {
                    //                        if let data = json as? NSDictionary {
                    //                        }
                    //                        else {
                    //                            if let obj = json.object(at: 0) as? NSNull {
                    //                            }
                    //                            else {
                    //                                if let data = json.object(at: 0) as? NSArray {
                    //                                    if data.count == 10 {
                    //                                        self.showLoadMore = true
                    //                                    }
                    //                                    else {
                    //                                        self.showLoadMore = false
                    //                                    }
                    //                                    self.customerData = json as! NSArray
                    //                                    //self.userArr = NSMutableArray(array: data)
                    //                                    //self.fullUserArr = self.userArr
                    //                                    DispatchQueue.main.async(execute: { () -> Void in
                    //                                        self.userTableView.reloadData()
                    //                                    })
                    //                                }
                    //
                    //                            }
                    //                        }
                    //                    }
                    //                    //self.userDataLoaded()
                    //                }
                }

                
            }
            
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            
        })
//
//        //database local
//        
//        
//        if (localDBObj.open()) {
//            // let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
//            let sql_stmt = "CREATE TABLE IF NOT EXISTS MAGENTO (ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, FIRSTNAME TEXT, LASTNAME TEXT, ENTITYID TEXT, EMAIL TEXT, MONTH TEXT, UPDATED TEXT)"
//            if !(localDBObj.executeStatements(sql_stmt)) {
//                print("Error: \(localDBObj.lastErrorMessage())")
//            }
//            localDBObj.close()
//        } else {
//            print("Error: \(localDBObj.lastErrorMessage())")
//        }
//        
//        
//        DispatchQueue.global(qos: .background).async {
//            
//            print("This is run on the background queue")
//            
//            var localDbUrl = "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&limit=\(self.totalCustomer)&page=1"
//            
//            let date = Date()
//            
//            
//            let calendar = Calendar.current
//            
//            let year = calendar.component(.year, from: date)
//            let lastMonth = calendar.component(.month, from: date) - 1
//            
//            if self.firstTimeLoad == false {
//                self.firstTimeLoad = true
//                if self.lastYearBool == true {
//                    localDbUrl = localDbUrl + "&year=\(year - 1)"
//                }
//                else if self.lastMonthBool == true {
//                    localDbUrl = localDbUrl + "&month=\(lastMonth)"
//                }
//            }
//            APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : false, onSuccess: { (json) in
//                
//                if let responseData = json as? NSDictionary {
//                    if let active = responseData.object(forKey: "active") as? Int {
//                        if active == 0 {
//                            if let message = responseData.object(forKey: "message") as? String {
//                                ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
//                            }
//                        }
//                        else {
//                            
//                        }
//                    }
//                }
//                else {
//                    
//                    if json.count > 0 {
//                        if let data = json as? NSDictionary {
//                            self.customerData = NSArray(object: data)
//                            
//                            self.userDataLoaded(totalArr: NSArray(object: data))
//                        }
//                        else {
//                            self.customerData = json as! NSArray
//                            self.userDataLoaded(totalArr: self.customerData.object(at: 0) as! NSArray)
//                        }
//                    }
//                }
//                
//            }, onFailure: { (error) in
//                print("Error2: \(error.localizedDescription)")
//                
//            })
//            
//            
//        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = "Category"
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        ObjRef.sharedInstance.setupNavigationBar(vc: self)

        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)

    }
    func navigationBtnLeftTapped() {
        if currentCatIndex == 0 {
            if self.fromEditProduct == true {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        if currentCatIndex == 1 {
            indexCategoryData.removeObjects(forKeys: [currentCatIndex])
        }
        currentCatIndex -= 1
        if currentCatIndex >= 0 {
            
            let cellDict = self.indexCategoryData.object(forKey: currentCatIndex) as! NSDictionary
            self.parentCatArr = (self.parentCategoryData["children"] as? NSArray)!
            
            self.title = cellDict.object(forKey: "name") as? String
            if currentCatIndex == 0 {
                self.title = "Category"
            }
            if let defCat = cellDict["children"] as? NSArray {
                if defCat.count > 0 {
                    self.SelectedCategoryData = cellDict
                   // currentCatIndex += 1
                    if let children = self.SelectedCategoryData["children"] as? NSArray {
                        self.categoryArr = NSMutableArray(array: children)
                        self.userTableView.reloadData()
                    }
                    if currentCatIndex == 0 && self.fromEditProduct == false {
                        self.navigationItem.setLeftBarButtonItems([pencilBarBtn], animated: false)

                    }
                    return
                }
            }

        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductTableViewCell
        let cellDict = self.categoryArr.object(at: indexPath.row) as! NSDictionary
        cell.catLab.text = cellDict.object(forKey: "name") as? String
        cell.catLab.font = ObjRef.sharedInstance.updateFont(fontName: (cell.catLab.font?.fontName)!, fontSize: 14)

        cell.selectionStyle = .none
        
        cell.catEditButton.tag = indexPath.row + 1
        cell.catDeleteButton.tag = indexPath.row + 1
        cell.selectBut.tag = indexPath.row
        
        cell.moreSubcategory.isHidden = true
        
        if let childrenAr = cellDict.object(forKey: "children") as? NSArray {
            if childrenAr.count > 0 {
                cell.moreSubcategory.isHidden = false
                cell.catLab.text = (cellDict.object(forKey: "name") as? String)!  + "(\(childrenAr.count))"
                cell.childButWidth.constant = cell.selectBut.frame.size.width
            }
            else {
                cell.moreSubcategory.isHidden = true
                cell.childButWidth.constant = 0

            }
        }

        if self.fromEditProduct == true {
            cell.catEditButton.isHidden = true
            cell.catDeleteButton.isHidden = true
            cell.selectBut.isHidden = false
            
            //cell.editButWidth.constant = 0
            //cell.childButWidth.constant = 0

        }
        else {
            //cell.editButWidth.constant = cell.selectBut.frame.size.width
            //cell.childButWidth.constant = cell.selectBut.frame.size.width


            //cell.selectBut.isHidden = true
        }
        
        let catId = cellDict.object(forKey: "category_id") as! String
        
        
        if idSelectedArr.count > 0 {
            for i in 0  ..< idSelectedArr.count  {
                let obj = self.idSelectedArr.object(at: i) as! String
                if catId == obj {
                    cell.selectBut.isSelected = true
                    //idSelectedArr.removeObject(at: i)
                    break
                }
                    
                else {
                    //idSelectedArr.add(catId)
                    cell.selectBut.isSelected = false
                }
            }
            
        }
        else {
            //idSelectedArr.add(catId)
            cell.selectBut.isSelected = false
            
        }

       // cell.catEditButton.addTarget(self, action: #selector(self.editProductTappedFromCell(button:)), for: UIControlEvents.touchUpInside)
       // cell.catDeleteButton.addTarget(self, action: #selector(self.deleteProductTappedFromCell(button:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellDict = self.categoryArr.object(at: indexPath.row) as! NSDictionary
        
        if let defCat = self.SelectedCategoryData["children"] as? NSArray {
            self.parentCatArr = defCat
        }
        if let defCat = cellDict["children"] as? NSArray {
            if defCat.count > 0 {
                self.SelectedCategoryData = cellDict
                currentCatIndex += 1
                self.title = cellDict.object(forKey: "name") as? String
                self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)

                indexCategoryData.addEntries(from: [currentCatIndex : self.SelectedCategoryData])

               // if let children = self.SelectedCategoryData["children"] as? NSArray {
                    self.categoryArr = NSMutableArray(array: defCat)
                    self.userTableView.reloadData()
               // }
                return
            }
        }

        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
       // self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - edit and delete funcitons
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: - edit and delete funcitons

    @IBAction func editProductTappedFromCell(button : UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditCategory") as! EditCategoryViewController
        //vc.parentCatArr = NSMutableArray(array: self.parentCatArr)
        vc.editBool = true
        let dictParent = self.categoryArr.object(at: button.tag - 1) as! NSDictionary
        vc.catName = (dictParent.object(forKey: "name") as? String)!
        vc.parentCategoryData = self.SelectedCategoryData
        vc.categoryData = dictParent
        vc.catId = dictParent.object(forKey: "category_id") as! String
        self.navigationController?.pushViewController(vc, animated: true)

    }

    
    @IBAction func deleteProductTappedFromCell(button : UIButton) {
        
        let alertCont = UIAlertController(title: "", message: "Do you want to delete this category", preferredStyle: UIAlertControllerStyle.alert)
        alertCont.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            self.deleteConfirm(button: button)
        }))
        alertCont.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alertCont, animated: true, completion: nil)

    }
    func deleteConfirm(button : UIButton) {
        
        let dictParent = self.categoryArr.object(at: button.tag - 1) as! NSDictionary
        let catId = dictParent.object(forKey: "category_id") as! String
        
        let localDbUrl = "category/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let dataPost = "delete_category_id=\(catId)"
        
        APIManager.sharedInstance.postRequestWithId(appendParam: localDbUrl, bodyData: dataPost, presentingView: self.view, onSuccess: { (json) in
            
            if let dict = json as? NSDictionary {
                if dict.count > 0 {
                        if let status = dict.object(forKey: "status") as? String {
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                if status == "success" {
                                    if let message = dict.object(forKey: "message") as? String {
                                        let alertCont = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                        alertCont.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                                            self.reloadTapped(UIButton())
                                        }))
                                        self.present(alertCont, animated: true, completion: nil)
                                    }
                                    
                                }
                                else {
                                    if let message = dict.object(forKey: "message") as? String {
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
                }
            else {
                
                
            }
            
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            
        })

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
