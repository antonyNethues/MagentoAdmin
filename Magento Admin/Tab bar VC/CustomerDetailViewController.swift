//
//  CustomerDetailViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 28/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit


class CustomerDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var custDetailTableView: UITableView!
    var customerId = String()
    var customerData = NSDictionary()
    var statusArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusArr = [false,false,false]
        APIManager.sharedInstance.getRequestWithId(appendParam: "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&customer_id=\(self.customerId)", presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        
                        if let data = responseData.object(forKey: "0") as? NSDictionary {
                            if data.count > 0 {
                                self.customerData = data
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.custDetailTableView.reloadData()
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
            
            _ = self.navigationController?.popViewController(animated: true)

            //UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        })

         self.navigationItem.setLeftBarButtonItems([], animated: false)

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItems = ObjRef.sharedInstance.navigationbarLeftButton(viewController: self, buttonImage: UIImage(named: "defaultBack")!)
        
    }
    func navigationBtnLeftTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func menuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let status = statusArr.object(at: section) as? Bool {
            if status == false {
                return 0
            }
        }
        if section == 0 {
            tableView.estimatedRowHeight = 300
            tableView.rowHeight = UITableViewAutomaticDimension
            
            
            return 1
        }
        else if section == 1 {
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableViewAutomaticDimension

            return 1
        }
        else if section == 2 {
            if let order = self.customerData["order"] as? NSArray {
                if order.count == 0 {
                    tableView.estimatedRowHeight = 60
                    tableView.rowHeight = UITableViewAutomaticDimension

                    return 1
                }
                tableView.estimatedRowHeight = 180
                tableView.rowHeight = UITableViewAutomaticDimension

                return order.count
            }

            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoCell") as! CustomerDetailTableViewCell

        let fontSize = 13

        if indexPath.section == 0 {
           
            cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoCell") as! CustomerDetailTableViewCell

            //cell.lastLogInlab.font = AppFont.boldFontSize(size: 11)
            cell.lastLogInlab.font = ObjRef.sharedInstance.updateFont(fontName: cell.lastLogInlab.font.fontName, fontSize: fontSize)
            cell.lastLogInValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.lastLogInValLab.font.fontName, fontSize: fontSize)
            
            cell.confEmailLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.confEmailLab.font.fontName, fontSize: fontSize)
            cell.confEmailVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.confEmailVallab.font.fontName, fontSize: fontSize)
            
            cell.accCreatOnLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.accCreatOnLab.font.fontName, fontSize: fontSize)
            cell.accCreatOnValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.accCreatOnValLab.font.fontName, fontSize: fontSize)
            
            cell.defBillingAdd.font = ObjRef.sharedInstance.updateFont(fontName: cell.defBillingAdd.font.fontName, fontSize: fontSize)
           // cell.lastLogInValLab.font = UIFont(name: cell.lastLogInlab.font.fontName, size: fontSize)!
            
            let fontSize2 = 16

            cell.defBIllingHeader.font = ObjRef.sharedInstance.updateFont(fontName: cell.defBIllingHeader.font.fontName, fontSize: fontSize2)
            
            //cell.bottomConst.constant = 0
            
            if let billing = self.customerData["billing"] as? NSDictionary {
                
                var name = String()
                var postcode = String()
                var street = String()
                var city = String()
                var region = String()
               // var region_id = String()
                var country_id = String()
                var telephone = String()
                
                
                if let firstname  = billing.object(forKey: "firstname") as? String {
                    name = firstname
                    if let lastname  = billing.object(forKey: "lastname") as? String {
                        name = firstname + " " + lastname
                    }
                    
                }
                if let postcodeVal  = billing.object(forKey: "postcode") as? String {
                    postcode = postcodeVal
                }

                if let streetVal  = billing.object(forKey: "street") as? String {
                    street = streetVal
                }
                if let cityVal  = billing.object(forKey: "city") as? String {
                    city = cityVal
                }
                if let regionVal  = billing.object(forKey: "region") as? String {
                    region = regionVal
                }
//                if let region_idVal = billing.object(forKey: "region_id") as? String {
//                    //region_id = region_idVal
//                }
                if let country_idVal  = billing.object(forKey: "country_id") as? String {
                    country_id = country_idVal
                }
                if let telephoneVal  = billing.object(forKey: "telephone") as? String {
                    telephone = telephoneVal
                }
//
                cell.defBillingAdd.text = "\(name)\n\(street)\n\(city), \(region), \(postcode)\n\(country_id)\nT: \(telephone) "
//                cell.defBillingAdd.numberOfLines = 6
//                cell.defBillingAdd.sizeToFit()
//                cell.addressConst.constant = cell.defBillingAdd.frame.size.height
            }
            else {
                cell.defBillingAdd.text = "No Data"
                cell.addressConst.constant = 40

            }
            if let lastLoggedIn = self.customerData["updated_at"] as? String {
                cell.lastLogInValLab.text = lastLoggedIn
            }
            if let created_at = self.customerData["created_at"] as? String {
                cell.accCreatOnValLab.text = created_at
            }
            if let email = self.customerData["email"] as? String {
                cell.confEmailVallab.text = email
            }
        }
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "SalesStatsCell") as! CustomerDetailTableViewCell
            
            cell.lifetLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.lifetLab.font.fontName, fontSize: fontSize)
            cell.lifeTValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.lifeTValLab.font.fontName, fontSize: fontSize)
            
            cell.avgLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.avgLab.font.fontName, fontSize: fontSize)
            cell.avgValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.avgValLab.font.fontName, fontSize: fontSize)

            if let avg_sale = self.customerData["avg_sale"] as? String {
                cell.avgValLab.text = avg_sale
            }
            if let lifetime_sale = self.customerData["lifetime_sale"] as? String {
                cell.lifeTValLab.text = lifetime_sale
            }
        }
        else if indexPath.section == 2 {
            if let order = self.customerData["order"] as? NSArray {
                if order.count == 0 {
                    return tableView.dequeueReusableCell(withIdentifier: "NoDataCell") as! CustomerDetailTableViewCell
                }
            }
            cell = tableView.dequeueReusableCell(withIdentifier: "RecentOrderCell") as! CustomerDetailTableViewCell
            
            cell.orderLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderLab.font.fontName, fontSize: fontSize)
            cell.orderVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderVallab.font.fontName, fontSize: fontSize)
            
            cell.purchasedOnLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.purchasedOnLab.font.fontName, fontSize: fontSize)
            cell.purchOnValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.purchOnValLab.font.fontName, fontSize: fontSize)
            
            cell.billToNamLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.billToNamLab.font.fontName, fontSize: fontSize)
            cell.billToNamValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.billToNamValLab.font.fontName, fontSize: fontSize)
            
            cell.orderTotalLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderTotalLab.font.fontName, fontSize: fontSize)
            cell.orderTotalValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderTotalValLab.font.fontName, fontSize: fontSize)

            if let order = self.customerData["order"] as? NSArray {
                let dict = order.object(at: indexPath.row) as! NSDictionary
                
                if let billing_name = dict["billing_name"] as? String {
                    cell.billToNamValLab.text = billing_name
                }
                if let id = dict["id"] as? String {
                    cell.orderVallab.text = id
                }
                if let order_total = dict["order_total"] as? String {
                    cell.orderTotalValLab.text = order_total
                }
                if let purchased_on = dict["purchased_on"] as? String {
                    cell.purchOnValLab.text = purchased_on
                }

            }
        }
        cell.selectionStyle = .none

        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            if (self.customerData["billing"] as? NSDictionary) != nil {
//                if self.view.frame.size.height == 320 {
//                    return 300
//                }
//                return 330
//            }
//            //if indexPath.section == 0 {
//            
//            return 270
//
//            //}
//
//           
//            //return 357
//        }
//        else if indexPath.section == 1 {
//            return 100
//        }
//        else if indexPath.section == 2 {
//            if let order = self.customerData["order"] as? NSArray {
//                if order.count == 0 {
//                    return 60
//                }
//            }
//
//            return 180
//        }
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        headView.tag = section
        headView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.headerTapped(gesture:))))
        
        headView.backgroundColor = ObjRef.sharedInstance.magentoOrange
        
        let image = UIImage(named: "downWhite")
        
        let imageV = UIImageView(image: image)
        imageV.frame = CGRect(x: headView.frame.size.width - (image?.size.width)!*2, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        imageV.center = headView.center
        imageV.frame.origin.x = tableView.frame.size.width - (image?.size.width)!*2
        headView.addSubview(imageV)
        
        let labTitle = UILabel(frame: headView.frame)
        if section == 0 {
            labTitle.text = " PERSONAL INFORMATION"
        }
        else if section == 1 {
            labTitle.text = " SALES STATISTICS"
        }
        else if section == 2 {
            labTitle.text = " RECENT ORDERS"
        }
        headView.addSubview(labTitle)
        labTitle.textColor = UIColor.white
        
        return headView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func headerTapped(gesture : UITapGestureRecognizer) {
        if let status = statusArr.object(at: (gesture.view?.tag)!) as? Bool {
            if status == false {
                statusArr.replaceObject(at: (gesture.view?.tag)!, with: true)
            }
            else {
                statusArr.replaceObject(at: (gesture.view?.tag)!, with: false)
            }
        }
        
        custDetailTableView.reloadData()
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
