//
//  RightViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

class RightViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomBar: UIImageView!
    @IBOutlet var menuTableView: UITableView!
    var indexSelected = Int()
    var BestSellarVC: UINavigationController?
    var ChangePassVC: UINavigationController?
    var MultistoreVC: UINavigationController?
    var imagesArr = NSArray()
    
    var reloadSuperTableviewTwice = Bool()
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var userName: UILabel!
    
    var websiteArr = NSArray()
    var currencyArr = NSArray()
    var languageArr = NSArray()

    var storeSelected = Int()

    var storeIndex = Int()
    var storeSectionIndex = Int()
    var websiteSelected = Int()
    var websiteSectionSelected = Int()

    var storeIdSelected = String()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        reloadSuperTableviewTwice = true
        
        indexSelected = 0
       // imagesArr = ["dash_menu.png","dash_menu.png","dash_menu.png","productLIst.png","category_menu.png","bestseller.png","customer_menu.png","order_menu.png","change_menu.png","logout_menu.png"]
        imagesArr = ["bestseller.png","change_menu.png","logout_menu.png"]
        
        bottomBar.backgroundColor = ObjRef.sharedInstance.magentoOrange
        
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor]
        
        //layerGradient.startPoint = CGPoint(x: 0, y: 0)
        //layerGradient.endPoint = CGPoint(x: 0, y:0.5 )
        
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = false;
        self.view.layer.shadowOffset = CGSize(width: 0, height: -10)
        self.view.layer.shadowRadius = 5;
        self.view.layer.shadowOpacity = 0.3;
        
        self.reloadButtonTapped(UIButton())

        self.userImage.layer.cornerRadius = self.userImage.frame.size.width*0.5
        self.userImage.layer.masksToBounds = true
        
        
        self.userName.text = ObjRef.sharedInstance.userName
        self.userEmail.text = ObjRef.sharedInstance.userEmail
        self.userName.sizeToFit()
        self.userEmail.sizeToFit()
        
        self.userName.font = ObjRef.sharedInstance.updateFont(fontName: (self.userName.font?.fontName)!, fontSize: 10)
        self.userEmail.font = ObjRef.sharedInstance.updateFont(fontName: (self.userEmail.font?.fontName)!, fontSize: 10)

    }
    
    @IBAction func languageSelectionTapped(_ sender: Any) {
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
        
        storeIndex = button.tag
        if let cellSuperV = button.superview?.superview as? RightMenuTableViewCell {
            storeSectionIndex = cellSuperV.tag
            if let cellSuperV = button.superview?.superview?.superview as? UITableView {
                websiteSelected = cellSuperV.tag
            }
            
        }
        
        self.menuTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillLayoutSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
    }
    @IBAction func reloadButtonTapped(_ sender: Any) {
        
        APIManager.sharedInstance.postRequestWithId(appendParam: "dashboard/getdata/", bodyData: "stores=1&token=ABCDEFGHIJKLMNOPQRSTUVWXYZ", presentingView: self.view, onSuccess: { (json) in
            
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        if let data = responseData.object(forKey: "data") as? NSArray {
                            if data.count > 0 {
                                //if data.count == 10 {
                                self.websiteArr = data
                                //}
                                // else {
                                //self.showLoadMore = false
                                //  }
                                //self.productData = data as! NSArray
                                //self.prodArr = NSMutableArray(array: data)
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.menuTableView.reloadData()
                                    //self.productTableView.setContentOffset(CGPoint.zero, animated: true)
                                    
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
            
        }) { (error) in
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 100 {

            return 2
        }
        if let webDict = self.websiteArr.object(at: tableView.tag) as? NSDictionary {//send tapped section
            if let stores = webDict.object(forKey: "stores") as? NSArray {
                return stores.count
                
            }
            
            
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {
            
            if section > 0 {
                tableView.estimatedRowHeight = 50
                tableView.rowHeight = UITableViewAutomaticDimension
                return imagesArr.count
            }
            
            tableView.estimatedRowHeight = 350
            tableView.rowHeight = UITableViewAutomaticDimension
            return self.websiteArr.count

            
            //return imagesArr.count
        }
        else  {
            
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableViewAutomaticDimension
            if let webDict = self.websiteArr.object(at: tableView.tag) as? NSDictionary {
                if let stores = webDict.object(forKey: "stores") as? NSArray {
                    if let storesDict  = stores.object(at: section) as? NSDictionary {
                            if let storeName = storesDict.object(forKey: "store_view") as? NSArray {//""
                                
                                return storeName.count
                            }
                    }
                }
                
                
            }
            return 0
        }
        

        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = RightMenuTableViewCell()
        
        if let cellObj = tableView.dequeueReusableCell(withIdentifier: "cell") as? RightMenuTableViewCell {
            cell = cellObj
        }
        if tableView.tag == 100 {
           
            
            
            if indexPath.section == 0 {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! RightMenuTableViewCell

                cell.languageTable.tag = indexPath.row
                
                if let webDict = self.websiteArr.object(at: indexPath.row) as? NSDictionary {
                    
                    if let stores = webDict.object(forKey: "website_name") as? String {
                        cell.menuLab.text = stores
                        cell.menuLab.textColor = UIColor.black

                        if indexPath.row == websiteSelected {
                            cell.menuLab.textColor = ObjRef.sharedInstance.magentoOrange
                        }
                    }
                }
                if cell.selectedState == true {
                    cell.languageTable.isHidden = false
                    cell.languageTable.delegate = self
                    cell.languageTable.dataSource = self

                    cell.languageTable.reloadData()
                    cell.languageTable.isScrollEnabled = false

                    //cell.topCellViewHeightConst.constant = cell.languageTable.frame.origin.y + cell.languageTable.contentSize.height
                    
                    
                    cell.languageTable.superview?.frame.size.height = cell.languageTable.contentSize.height
                    
                    cell.languageTable.layoutIfNeeded()
                    cell.tableHeightConst.constant = cell.languageTable.contentSize.height
                    cell.languageTable.updateConstraints()
                    
                    if reloadSuperTableviewTwice == true {
                        reloadSuperTableviewTwice = false
                        tableView.reloadData()
                    }

                   // tableView.reloadData()
                }
                else {
                    cell.languageTable.isHidden = true
                    cell.tableHeightConst.constant =  0

                    //cell.topCellViewHeightConst.constant = cell.languageTable.frame.origin.y
                   // tableView.reloadData()
                }
                
                cell.languageTable.tag = indexPath.row
                cell.tag = indexPath.section
            }
            else {
                if indexSelected == indexPath.row {
                     //cell.menuLab.textColor = UIColor.black
                }
                else {
                    // cell.menuLab.textColor = UIColor.lightGray
                }
                if indexPath.row == 0 {
                    cell.menuLab.text = "Best Sellers"
                }
                    //        else if indexPath.row == 6 {
                    //            cell.menuLab.text = "Customers"
                    //        }
                    //        else if indexPath.row == 7 {
                    //            cell.menuLab.text = "Orders"
                    //        }
                else if indexPath.row == 1 {
                    cell.menuLab.text = "Change Password"
                }
                else if indexPath.row == 2 {
                    cell.menuLab.text = "Logout"
                }
                
                let imageName = self.imagesArr.object(at: indexPath.row) as! String
            }
            //cell.menuSectionImage.image = UIImage(named: imageName)
            return cell

        }
        else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cellLanguage") as! RightMenuTableViewCell

            if let webDict = self.websiteArr.object(at: tableView.tag) as? NSDictionary {
                if let stores = webDict.object(forKey: "stores") as? NSArray {
                    if let storesDict  = stores.object(at: indexPath.section) as? NSDictionary {
                        if let langArr = storesDict.object(forKey: "store_view") as? NSArray {//""
                            
                            if let langDict = langArr.object(at: indexPath.row) as? NSDictionary {
                                if let lang = langDict.object(forKey: "store_view_name") as? String {
                                    cell.languageLab.text = lang//store_view_id
                                    if let store_view_id = langDict.object(forKey: "store_view_id") as? String {
                                        storeIdSelected = store_view_id
                                        ObjRef.sharedInstance.storeIdSelected = storeIdSelected
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                cell.languageButton.tag = indexPath.row
                cell.tag = indexPath.section
                cell.languageButton.isSelected = false
                cell.languageLab.textColor = UIColor.black

                if cell.languageButton.tag == storeIndex {
                    if cell.tag == storeSectionIndex {
                        if tableView.tag == websiteSelected {
                            cell.languageButton.isSelected = true
                            cell.languageLab.textColor = ObjRef.sharedInstance.magentoOrange
                        }
                    }
                    
                }
            }
            
            //tableView.reloadData()
            
            //cell.tableHeightConst.constant =  cell.languageTable.contentSize.height
            
           // menuTableView.reloadData()
            return cell

        }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0  {
            if tableView.tag == 100 {
                if section == 0  {
                    return 50
                }
                else {
                    return 0
                }
            }
            
            
        }
        
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag != 100 {
            let viewHeader = UIView(frame: CGRect(x: 10, y: 0, width: self.view.frame.size.width, height: 50))
            viewHeader.backgroundColor = UIColor.lightGray
            let lab = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.frame.size.width - 20, height: 50))
            lab.text = ""
            if let webDict = self.websiteArr.object(at: tableView.tag) as? NSDictionary {
                if let stores = webDict.object(forKey: "stores") as? NSArray {
                        if let storesDict = stores.object(at: section) as? NSDictionary {
                            if let storeName = storesDict.object(forKey: "store_name") as? String {//""
                                lab.text = storeName
                            }
                        }
                    
                }
                
                
            }
            lab.textColor = UIColor.black

            if section == storeSectionIndex && tableView.tag == websiteSelected {
                lab.textColor = ObjRef.sharedInstance.magentoOrange
            }
            viewHeader.addSubview(lab)
            return viewHeader
            
        }
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        viewHeader.backgroundColor = ObjRef.sharedInstance.magentoOrange2

        let lab = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.frame.size.width - 20, height: 50))
        lab.text = "All Store View"
        if section == 1 {
            lab.text = "Menu"
        }
        lab.textColor = UIColor.white
//
//        if section == websiteSelected {
//            lab.textColor = ObjRef.sharedInstance.magentoOrange
//        }
        
        viewHeader.addSubview(lab)
        
        let image = UIImage(named: "downWhite")
        
        let imageV = UIImageView(image: image)
        imageV.frame = CGRect(x: viewHeader.frame.size.width - (image?.size.width)!*2, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        imageV.center = viewHeader.center
        imageV.frame.origin.x = tableView.frame.size.width - (image?.size.width)!*2
        viewHeader.addSubview(imageV)
        
        return viewHeader
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 100 {
            
            indexSelected = indexPath.row
            //self.menuTableView.reloadData()
            
            if indexPath.section == 0 {
                
                if let cell = tableView.cellForRow(at: indexPath) as? RightMenuTableViewCell {
                    
                    cell.selectedState = !cell.selectedState
                    
                        reloadSuperTableviewTwice = true
                    
                        tableView.reloadData()
//                    tableView.layoutIfNeeded()
//                    tableView.reloadData()
//                    tableView.updateConstraints()
                    
                }
                
            }
            else {
                if indexPath.row == 0 {
                    (self.parent as! HomeViewController).showActionSheet()
                }
                    //        else if indexPath.row == 2 {
                    //            let vc = self.parent as! HomeViewController
                    //            vc.tabBar(vc.customTabBar, didSelect: vc.dashboardItem)
                    //            vc.customTabBar.selectedItem = vc.dashboardItem
                    //            vc.slideMenuController()?.closeLeft()
                    //
                    //        }
                    //        else if indexPath.row == 3 {
                    //            let vc = self.parent as! HomeViewController
                    //            vc.tabBar(vc.customTabBar, didSelect: vc.productItem)
                    //            vc.customTabBar.selectedItem = vc.productItem
                    //            vc.slideMenuController()?.closeLeft()
                    //
                    //        }
                    //        else if indexPath.row == 4 {
                    //            let vc = self.parent as! HomeViewController
                    //            vc.tabBar(vc.customTabBar, didSelect: vc.CategoryItem)
                    //            vc.customTabBar.selectedItem = vc.CategoryItem
                    //            vc.slideMenuController()?.closeLeft()
                    //
                    //        }
                else if indexPath.row == 1 {
                    
                    
                    if BestSellarVC == nil {
                        
                        BestSellarVC = self.storyboard?.instantiateViewController(withIdentifier: "BestSellarVC") as? UINavigationController
                        self.addChildViewController(BestSellarVC!)
                        (self.parent)?.addChildViewController(BestSellarVC!)
                        
                    }
                    (self.parent as! HomeViewController).view.insertSubview(BestSellarVC!.view!, belowSubview: (self.parent as! HomeViewController).customTabBar)
                    (self.parent as! HomeViewController).closeLeft()
                    
                }
                    //        else if indexPath.row == 6 {
                    //
                    //            let vc = self.parent as! HomeViewController
                    //            vc.tabBar(vc.customTabBar, didSelect: vc.customerItem)
                    //            vc.customTabBar.selectedItem = vc.customerItem
                    //            vc.slideMenuController()?.closeLeft()
                    //
                    //        }
                    //        else if indexPath.row == 7 {
                    //
                    //            let vc = self.parent as! HomeViewController
                    //            vc.tabBar(vc.customTabBar, didSelect: vc.orderItem)
                    //            vc.customTabBar.selectedItem = vc.orderItem
                    //            vc.slideMenuController()?.closeLeft()
                    //
                    //        }
                else if indexPath.row == 2 {
                    
                    
                    if ChangePassVC == nil {
                        
                        ChangePassVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassword") as? UINavigationController
                        self.addChildViewController(ChangePassVC!)
                        (self.parent)?.addChildViewController(ChangePassVC!)
                        
                    }
                    (self.parent as! HomeViewController).view.insertSubview(ChangePassVC!.view!, belowSubview: (self.parent as! HomeViewController).customTabBar)
                    (self.parent as! HomeViewController).closeLeft()
                    
                    
                    
                }
                else if indexPath.row == 3 {
                    APIManager.sharedInstance.postRequestWithId(appendParam: "user/logout/", bodyData: "id=\(APIManager.sharedInstance.websiteId)&device_token=\(APIManager.sharedInstance.websiteToken)&token=ABCDEFGHIJKLMNOPQRSTUVWXYZ", presentingView: self.view, onSuccess: { (response) in
                        
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
                                
                                if let success = response["success"] as? Bool {
                                    if success == true {
                                        UserDefaults.standard.set(0, forKey: "alreadyLogin")
                                        UserDefaults.standard.synchronize()
                                        
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanVC") as? UINavigationController
                                        self.parent?.present(vc!, animated: true, completion: nil)
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                    }, onFailure: { (error) in
                        
                    })
                    
                }
            }
        }
        else {
            
            if let cell = tableView.cellForRow(at: indexPath) as? RightMenuTableViewCell {
                
                self.languageSelectionTapped(cell.languageButton)
                
            }
        }
    }
}
