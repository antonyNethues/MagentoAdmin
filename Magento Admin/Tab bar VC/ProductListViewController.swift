//
//  ProductListViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 04/10/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit


class ProductListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,SearchProdFilterDelegate,EditProductDelegate {
    
    @IBOutlet var productTableView: UITableView!
    var boolVal = Int()
    var productListArr = NSMutableArray()
    var filterValName = String()
    var showLoadMore = Bool()
    var dataLoaded = Bool()
    var currentIndex = Int()
    var firstTimeLoad = Bool()
    var productData = NSArray()
    var localDBObj = FMDatabase()
    var totalProduct = Int()
    var filterValChanged = Bool()

    var prodArr = NSMutableArray()
    

    @IBAction func MenuTapped(_ sender: Any) {
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())
    }
    func updateProductListing() {
        self.reloadTapped(UIButton())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dict = [
            "name" : "name",
            "price" : "price",
            "image" : ""]
        
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        productListArr.add(dict)
        
        //productTableView.reloadData()
        
        // Do any additional setup after loading the view.
        let searchImage = UIImage(named: "search2")!
        let clipImage = UIImage(named: "refresh")!
        let pencilImage = UIImage(named: "menu")!
        let addImage = UIImage(named: "add")!
        
        let addBtn: UIButton = UIButton()
        addBtn.setImage(addImage, for: UIControlState.normal)
        addBtn.addTarget(self, action: #selector(self.addTapped), for: UIControlEvents.touchUpInside)
        addBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let addBarBtn = UIBarButtonItem(customView: addBtn)

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
        pencilBtn.addTarget(self, action: #selector(self.menuTapped(_:)), for: UIControlEvents.touchUpInside)
        pencilBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let pencilBarBtn = UIBarButtonItem(customView: pencilBtn)
        
        self.navigationItem.setRightBarButtonItems([clipBarBtn, searchBarBtn,addBarBtn], animated: false)
        self.navigationItem.setLeftBarButtonItems([pencilBarBtn], animated: false)
        
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = ObjRef.sharedInstance.magentoOrange

        localDBObj = MagentoDatabase.sharedInstance.MagentoDB

        DispatchQueue.global(qos: .background).sync {
            
            if (self.localDBObj.open()) {
                
                let dropTable = "DELETE FROM PRODUCTS"
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

        self.reloadTapped(UIButton())
        // Do any additional setup after loading the view.
    }
    
    func addTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProduct") as! EditProductViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func menuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())
        
    }
    @IBAction func searchFilterTapped(_ sender: Any) {
        
        
        
        if sender is UIButton {
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.productTableView.setContentOffset(CGPoint.zero, animated: true)
            })
            
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
                self.prodArr = NSMutableArray()
                
            }
        }
        
        //backFromSearchFilter = false
        var querySQL = "SELECT * FROM PRODUCTS WHERE "
       // var querySQL = "SELECT * FROM PRODUCTS "
        //SELECT * FROM table WHERE
        var checkAccess = Int()
        checkAccess = 0
        
        
        
        if filterValName.characters.count > 0 {
            querySQL = querySQL + "name Like '%\(filterValName)%' AND "
            checkAccess = 1
        }
        
        
        
        if checkAccess == 1 {
            let endIndex = querySQL.index(querySQL.endIndex, offsetBy: -4)
            let truncated = querySQL.substring(to: endIndex)
            
            querySQL = truncated
        }
        else if checkAccess == 0 {
            
            querySQL = "SELECT * FROM PRODUCTS "
            
        }
        
        if self.currentIndex == 0 {
            self.prodArr = NSMutableArray()
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
                    
                    self.prodArr.add(dict)
                }
                
                if counter == 10 {
                    self.showLoadMore = true
                }
                else {
                    self.showLoadMore = false
                }
                self.productTableView.reloadData()
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
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchProductViewController") as! SearchProductViewController
        vc.nameVal = self.filterValName
        
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func reloadTapped(_ sender: Any) {
        
        self.loadNewDataWithLocalUpdate()
        
    }
    func sendDataOfUser(name: String) {
        
        self.filterValName = name
        self.searchFilterTapped(UIButton())
    }

    func loadNewDataWithLocalUpdate() {
        

        self.dataLoaded = false
        self.currentIndex = 0
        let date = Date()
        let calendar = Calendar.current
        
        _ = calendar.component(.year, from: date)
        _ = calendar.component(.month, from: date) - 1
        
        let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&limit=10&page=\(self.currentIndex)"
        
        APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        if let data = responseData.object(forKey: "data") as? NSArray {
                            if data.count > 0 {
                                if data.count == 10 {
                                    self.showLoadMore = true
                                }
                                else {
                                    self.showLoadMore = false
                                }
                                self.productData = data as! NSArray
                                self.prodArr = NSMutableArray(array: data)
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.productTableView.reloadData()
                                    self.productTableView.setContentOffset(CGPoint.zero, animated: true)
                                    
                                })
                                //self.userDataLoaded()
                            }
                        }
                    }
                    else {
                        if let message = responseData.object(forKey: "message") as? String {
                            ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                        }
                    }
                }
            }
            
            
        }, onFailure: { (error) in
            print("Error2: \(error.localizedDescription)")
            
        })
        
        //database local
        
        //return
        
        
        DispatchQueue.global(qos: .background).sync {
            
            if (localDBObj.open()) {
                // let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                let sql_stmt = "CREATE TABLE IF NOT EXISTS PRODUCTS (ID INTEGER PRIMARY KEY AUTOINCREMENT,ENTITYID TEXT, NAME TEXT, PRICE INTEGERF, IMAGELINK TEXT, THUMBIMAGELINK TEXT, DESC TEXT, STATUS TEXT, STOCK TEXT,CREATED_AT TEXT,UPDATED_AT TEXT)"
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
            
            if self.firstTimeLoad == false {
                self.firstTimeLoad = true
                
            }
            APIManager.sharedInstance.getRequestWithId(appendParam: localDbUrl, presentingView: self.view,showLoader : false, onSuccess: { (json) in
                
                if let responseData = json as? NSDictionary {
                    if let active = responseData.object(forKey: "status") as? String {
                        if active == "success" {
                            if let data = responseData.object(forKey: "data") as? NSArray {
                                DispatchQueue.global(qos: .background).sync {
                                    self.productData = data
                                    self.userDataLoaded(totalArr:  data)
                                }
                            }
                            
                            
                        }
                        else {
                            if let message = responseData.object(forKey: "message") as? String {
                                ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                            }
                        }
                    }
                }
                else {
                    

                }
                
            }, onFailure: { (error) in
                print("Error2: \(error.localizedDescription)")
                
            })
            
            
        }
        
    }
    func userDataLoaded(totalArr : NSArray) {
        //database local
        
        
        
        if (localDBObj.open()) {
            //CREATE TABLE IF NOT EXISTS PRODUCTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PRICE INTEGERF, IMAGELINK TEXT, THUMBIMAGELINK TEXT, DESC TEXT, STATUS TEXT, STOCK TEXT
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
            //localDBObj.close()
            
            
        } else {
            print("Error: \(localDBObj.lastErrorMessage())")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = "Product"
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        ObjRef.sharedInstance.setupNavigationBar(vc: self)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if prodArr.count == 0 {
            return 1
        }
        if showLoadMore == false {
            return self.prodArr.count
        }
        return 1 + self.prodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductListTableViewCell
        
        if prodArr.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "NoRecordsCell") as! ProductListTableViewCell

        }
        
        if indexPath.row == prodArr.count {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! ProductListTableViewCell
            return cell
            
        }
        else {
            
            let dict = self.prodArr.object(at: indexPath.row) as! NSDictionary
            cell.productName.text = dict.object(forKey: "name") as? String
            cell.productPrice.text = dict.object(forKey: "price") as? String
            if let strPrice = dict.object(forKey: "price") as? String {
                cell.productPrice.updateCurrency(str: strPrice)
            }
            else {
               // cell.productPrice.text = "0"
            }
            let imageUrl = dict.object(forKey: "thumbnail") as? String

            cell.deleteButton.tag = indexPath.row
            cell.editButton.tag = indexPath.row

            //let imageUrlAfterRemovingSlashes = imageUrl?.replacingOccurrences(of: "\\", with: "")
            //cell.ProductImage.text = dict.object(forKey: "image") as! String
            let fontSize = 14
            //print("image - ",imageUrl)
            
            cell.ProductImage.sd_setShowActivityIndicatorView(true)
            cell.ProductImage.sd_setIndicatorStyle(.gray)
            if imageUrl != nil {
                cell.ProductImage.sd_setImage(with: URL(string: imageUrl!), completed: nil)
            }
//            cell.ProductImage.sd_setImage(with: URL(fileURLWithPath: imageUrl!), completed: { (image, error, imageType, url) in
//                cell.ProductImage.image = image
//            })
            
           // self.downloadImage(url: URL(fileURLWithPath: imageUrl!), imageView: cell.ProductImage)
            cell.productName.font = ObjRef.sharedInstance.updateFont(fontName: (cell.productName.font?.fontName)!, fontSize: fontSize)
            cell.productPrice.font = ObjRef.sharedInstance.updateFont(fontName: (cell.productPrice.font?.fontName)!, fontSize: fontSize)

            cell.selectionStyle = .none
            
        }
        return cell
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
            print(error?.localizedDescription)
            }.resume()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == prodArr.count && self.showLoadMore == true {
            if dataLoaded == true {
                self.currentIndex += 1
                self.searchFilterTapped(UIView())
            }
            else {
                self.currentIndex += 1
                APIManager.sharedInstance.getRequestWithId(appendParam: "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&limit=10&page=\(currentIndex)", presentingView: self.view,showLoader : true, onSuccess: { (json) in
                    
                    if let responseData = json as? NSDictionary {
                        if let active = responseData.object(forKey: "status") as? String {
                            if active == "success" {
                                if let data = responseData.object(forKey: "data") as? NSArray {
                                if data.count > 0 {
                                        if data.count == 10 {
                                            self.showLoadMore = true
                                        }
                                        else {
                                            self.showLoadMore = false
                                        }
                                        
                                        self.productData = data as! NSArray
                                        self.prodArr.addObjects(from: data as! [Any])
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            self.productTableView.reloadData()
                                        })
                                        
                                }
                                }
                            }
                            else {
                                if let message = responseData.object(forKey: "message") as? String {
                                    ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                                }
                            }
                        }
                        
                    }
                    else {
                        

                    }
                    
                }, onFailure: { (error) in
                    
                    
                })
            }
            
            
            return
        }
       // return
        let dict = self.prodArr.object(at: indexPath.row) as! NSDictionary

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.productDetail = dict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 20))
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let button = sender as! UIButton
        
        let alertCont = UIAlertController(title: "", message: "Do you want to delete this product", preferredStyle: UIAlertControllerStyle.alert)
        alertCont.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            self.deleteConfirm(button: button)
        }))
        alertCont.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alertCont, animated: true, completion: nil)
        
    }
    
    func deleteConfirm(button : UIButton) {
        
        let dictParent = self.prodArr.object(at: button.tag) as! NSDictionary
        let prodId = dictParent.object(forKey: "entity_id") as! String
        
        let localDbUrl = "product/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let dataPost = "delete_product_id=\(prodId)"
        
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
    @IBAction func editButtonTapped(_ sender: Any) {
        
        let button = sender as! UIButton
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProduct") as! EditProductViewController
        let dictParent = self.prodArr.object(at: button.tag) as! NSDictionary
        vc.productData = dictParent
        vc.editBool = true
        vc.prodId = dictParent.object(forKey: "entity_id") as! String
        vc.productName = dictParent.object(forKey: "name") as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - table Button selector
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
