//
//  OrderDetailViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 28/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var orderId = String()
    @IBOutlet var orderDetailTableView: UITableView!
    var orderData = NSDictionary()
    var itemsArr = NSArray()
    var statusArr = NSMutableArray()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        statusArr = [false,false,false,false,false,false,false,false]

        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        // Do any additional setup after loading the view.
        
        //navigation bar right button
        
        let searchImage = UIImage(named: "search2")!
        let clipImage = UIImage(named: "refresh")!
        let pencilImage = UIImage(named: "menu")!
        
        let searchBtn: UIButton = UIButton()
        searchBtn.setImage(searchImage, for: UIControlState.normal)
        searchBtn.addTarget(self, action: Selector(("searchBtnPressed")), for: UIControlEvents.touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        _ = UIBarButtonItem(customView: searchBtn)
        
        let clipBtn: UIButton = UIButton()
        clipBtn.setImage(clipImage, for: UIControlState.normal)
        // clipBtn.addTarget(self, action: Selector("searchBtnPressed"), for: UIControlEvents.touchUpInside)
        clipBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        _ = UIBarButtonItem(customView: clipBtn)
        
        let pencilBtn: UIButton = UIButton()
        pencilBtn.setImage(pencilImage, for: UIControlState.normal)
        pencilBtn.addTarget(self, action: #selector(self.menuTapped(_:)), for: UIControlEvents.touchUpInside)
        pencilBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        _ = UIBarButtonItem(customView: pencilBtn)
        
        //self.navigationItem.setRightBarButtonItems([pencilBarBtn], animated: false)
        //self.navigationItem.setLeftBarButtonItems([pencilBarBtn], animated: false)

        APIManager.sharedInstance.getRequestWithId(appendParam: "order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&increment_id=\(self.orderId)", presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
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
                        if let data = responseData.object(forKey: "data") as? NSDictionary {
                            
                            self.orderData = data
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.orderDetailTableView.reloadData()
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
            
        }, onFailure: { (error) in
            
            _ = self.navigationController?.popViewController(animated: true)

            
        })

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
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let status = statusArr.object(at: section) as? Bool {
            if status == false {
                return 0
            }
        }
        if section == 0 {
            tableView.estimatedRowHeight = 141
            tableView.rowHeight = UITableViewAutomaticDimension

            return 1
        }
        else if section == 1 {
            tableView.estimatedRowHeight = 113
            tableView.rowHeight = UITableViewAutomaticDimension

            return 1
        }
        else if section == 2 {
            tableView.estimatedRowHeight = 156
            tableView.rowHeight = UITableViewAutomaticDimension

            return 1
        }
        else if section == 3 {
            tableView.estimatedRowHeight = 156
            tableView.rowHeight = UITableViewAutomaticDimension

            return 1
        }
        else if section == 4 {
            tableView.estimatedRowHeight = 86
            tableView.rowHeight = UITableViewAutomaticDimension

            return 1
        }
        else if section == 5 {
            tableView.estimatedRowHeight = 70
            tableView.rowHeight = UITableViewAutomaticDimension

            return 1
        }
        else if section == 6 {
            if let items  = self.orderData.object(forKey: "items") as? NSArray {
                if items.count == 1 {
                    tableView.estimatedRowHeight = 60
                    tableView.rowHeight = UITableViewAutomaticDimension

                    return 1
                }
                tableView.estimatedRowHeight = 209
                tableView.rowHeight = UITableViewAutomaticDimension

                self.itemsArr = items
            }
            return self.itemsArr.count
            
        }
        else if section == 7 {
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableViewAutomaticDimension

            return 1
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as! OrderDetailTableViewCell
        //cell.selectionStyle = .none

        let fontSize = 13
        if Screen.width == 320 {
            //yfontSize = 13
        }
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as! OrderDetailTableViewCell
            
            cell.orderIdLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderIdLab.font.fontName, fontSize: fontSize)
            cell.orderIdVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderIdVallab.font.fontName, fontSize: fontSize)
            
            cell.orderDateLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderDateLab.font.fontName, fontSize: fontSize)
            cell.orderDateVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderDateVallab.font.fontName, fontSize: fontSize)
            
            cell.orderStatusLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderStatusLab.font.fontName, fontSize: fontSize)
            cell.orderStatusVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.orderStatusVallab.font.fontName, fontSize: fontSize)
            
            
            if let billing_address_idVal = self.orderData["order_id"] as? String {//billing_address_id  ##old key
                cell.orderIdVallab.text = billing_address_idVal
            }
            if let created_atVal = self.orderData["created_at"] as? String {
                cell.orderDateVallab.text = created_atVal
            }
            if let status = self.orderData["status"] as? String {
                cell.orderStatusVallab.text = status
            }
        }
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "acInfoCell") as! OrderDetailTableViewCell
            
            cell.custNameLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.custNameLab.font.fontName, fontSize: fontSize)
            cell.custNameValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.custNameValLab.font.fontName, fontSize: fontSize)
            
            cell.emailLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.emailLab.font.fontName, fontSize: fontSize)
            cell.eamilValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.eamilValLab.font.fontName, fontSize: fontSize)

            if let firstname  = self.orderData.object(forKey: "customer_firstname") as? String {
                cell.custNameValLab.text = firstname
                if let lastname  = self.orderData.object(forKey: "customer_lastname") as? String {
                    cell.custNameValLab.text = firstname + " " + lastname
                }
                
            }
            if let customer_email = self.orderData["customer_email"] as? String {
                cell.eamilValLab.text = customer_email
            }

            //customer_email
        }
        else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "billAddCell") as! OrderDetailTableViewCell
            
            cell.billingAddVal.font = ObjRef.sharedInstance.updateFont(fontName: cell.billingAddVal.font.fontName, fontSize: fontSize)

            if let billing = self.orderData["billing_address"] as? NSDictionary {
                
                var name = String()
                var postcode = String()
                var street = String()
                var city = String()
                var region = String()
                //var region_id = String()
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
//                if let region_idVal  = billing.object(forKey: "region_id") as? String {
//                    region_id = region_idVal
//                }
                if let country_idVal  = billing.object(forKey: "country_id") as? String {
                    country_id = country_idVal
                }
                if let telephoneVal  = billing.object(forKey: "telephone") as? String {
                    telephone = telephoneVal
                }
                //
                cell.billingAddVal.text = "\(name)\n\(street)\n\(city), \(region), \(postcode)\n\(country_id)\nT: \(telephone) "
                
            }
            else {
                //cell.addressConst.constant = 40
                
            }

        }
        else if indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "shipAddCell") as! OrderDetailTableViewCell
            
            cell.shippingAddVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.shippingAddVallab.font.fontName, fontSize: fontSize)

            
            if let billing = self.orderData["shipping_address"] as? NSDictionary {
                
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
//                if let region_idVal  = billing.object(forKey: "region_id") as? String {
//                    region_id = region_idVal
//                }
                if let country_idVal  = billing.object(forKey: "country_id") as? String {
                    country_id = country_idVal
                }
                if let telephoneVal  = billing.object(forKey: "telephone") as? String {
                    telephone = telephoneVal
                }
                //
                cell.shippingAddVallab.text = "\(name)\n\(street)\n\(city), \(region), \(postcode)\n\(country_id)\nT: \(telephone) "
                
            }
            else {
                //cell.addressConst.constant = 40
                
            }

        }
        else if indexPath.section == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "paymentInfoCell") as! OrderDetailTableViewCell
            
            cell.paymentInfoLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.paymentInfoLab.font.fontName, fontSize: fontSize)
            
            if let paymentMethod  = self.orderData.object(forKey: "payment_method_title") as? String {
                //payment_method_title
                //order_currency_code
                if let paymentCurr  = self.orderData.object(forKey: "order_currency_code") as? String {
                    
                    let paymentStr = "Payment By " + paymentMethod + " order was placed using " + paymentCurr
                    cell.paymentInfoLab.text = paymentStr
                    
                }
            }
            
        }
        else if indexPath.section == 5 {
            cell = tableView.dequeueReusableCell(withIdentifier: "shipHandleCell") as! OrderDetailTableViewCell
            
            cell.shippingLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.shippingLab.font.fontName, fontSize: fontSize)
            cell.shippingVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.shippingVallab.font.fontName, fontSize: fontSize)
            
            if let shipping_amount  = self.orderData.object(forKey: "shipping_amount") as? String {
                cell.shippingVallab.text = shipping_amount
                cell.shippingVallab.updateCurrency(str: shipping_amount)
            }
            //shipping_amount

        }
        else if indexPath.section == 6 {
            if let items  = self.orderData.object(forKey: "items") as? NSArray {
                if items.count == 1 {
                    return tableView.dequeueReusableCell(withIdentifier: "NoDataCell") as! OrderDetailTableViewCell
                }
            }
            cell = tableView.dequeueReusableCell(withIdentifier: "itemOrderedCell") as! OrderDetailTableViewCell
            
            cell.prodnameLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.prodnameLab.font.fontName, fontSize: fontSize)
            cell.prodNameValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.prodNameValLab.font.fontName, fontSize: fontSize)
            
            cell.refCodeLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.refCodeLab.font.fontName, fontSize: fontSize)
            cell.refCodeVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.refCodeVallab.font.fontName, fontSize: fontSize)
            
            cell.priceLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.priceLab.font.fontName, fontSize: fontSize)
            cell.priceValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.priceValLab.font.fontName, fontSize: fontSize)
            
            cell.qtyLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.qtyLab.font.fontName, fontSize: fontSize)
            cell.qtyValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.qtyValLab.font.fontName, fontSize: fontSize)
            
            cell.subtotalLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.subtotalLab.font.fontName, fontSize: fontSize)
            cell.subtotalValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.subtotalValLab.font.fontName, fontSize: fontSize)
            
            cell.taxAmountLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.taxAmountLab.font.fontName, fontSize: fontSize)
            cell.taxAmtVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.taxAmtVallab.font.fontName, fontSize: fontSize)
            
            cell.discAmtLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.discAmtLab.font.fontName, fontSize: fontSize)
            cell.discAmtVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.discAmtVallab.font.fontName, fontSize: fontSize)
            
            cell.rowTotalLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.rowTotalLab.font.fontName, fontSize: fontSize)
            cell.rowTotalValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.rowTotalValLab.font.fontName, fontSize: fontSize)
            
            if let items  = self.orderData.object(forKey: "items") as? NSArray {
                self.itemsArr = items
                let dict = self.itemsArr.object(at: indexPath.row) as! NSDictionary
                
                if let name = dict.object(forKey: "name") as? String {
                    cell.prodNameValLab.text = name
                }
                if let sku = dict.object(forKey: "sku") as? String {
                    cell.refCodeVallab.text = sku
                }
                if let price = dict.object(forKey: "price") as? String {
                    cell.priceValLab.text = price
                    cell.priceValLab.updateCurrency(str: price)

                }
                if let qty_ordered = dict.object(forKey: "qty_ordered") as? String {
                    cell.qtyValLab.text = qty_ordered
                }
                if let tax_amount = dict.object(forKey: "tax_amount") as? String {
                    cell.taxAmtVallab.text = tax_amount
                    cell.taxAmtVallab.updateCurrency(str: tax_amount)

                }
                if let discount_amount = dict.object(forKey: "discount_amount") as? String {
                    cell.discAmtVallab.text = discount_amount
                    cell.discAmtVallab.updateCurrency(str: discount_amount)

                }
                if let row_total = dict.object(forKey: "row_total") as? String {
                    cell.rowTotalValLab.text = row_total
                    cell.rowTotalValLab.updateCurrency(str: row_total)

                }
                if let grand_base_total = dict.object(forKey: "base_subtotal") as? String {
                    cell.subtotalValLab.text = grand_base_total
                    cell.subtotalValLab.updateCurrency(str: grand_base_total)

                }
                //grand_base_total
            }

            

        }
        else if indexPath.section == 7 {
            cell = tableView.dequeueReusableCell(withIdentifier: "orderTotalCell") as! OrderDetailTableViewCell
            
            cell.subtotalOrderLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.subtotalOrderLab.font.fontName, fontSize: fontSize)
            cell.subtotalOrderVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.subtotalOrderVallab.font.fontName, fontSize: fontSize)
            
            cell.shipAndHandLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.shipAndHandLab.font.fontName, fontSize: fontSize)
            cell.shipAndHandVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.shipAndHandVallab.font.fontName, fontSize: fontSize)
            
            cell.taxLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.taxLab.font.fontName, fontSize: fontSize)
            cell.taxValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.taxValLab.font.fontName, fontSize: fontSize)
            
            cell.grandTotalLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.grandTotalLab.font.fontName, fontSize: fontSize)
            cell.grandTotalVallab.font = ObjRef.sharedInstance.updateFont(fontName: cell.grandTotalVallab.font.fontName, fontSize: fontSize)
            
            cell.totalPaidLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.totalPaidLab.font.fontName, fontSize: fontSize)
            cell.totalPaidValLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.totalPaidValLab.font.fontName, fontSize: fontSize)
            
            if let base_subtotal  = self.orderData.object(forKey: "base_subtotal") as? String {
                cell.subtotalOrderVallab.text = base_subtotal
                cell.subtotalOrderVallab.updateCurrency(str: base_subtotal)

            }
            if let base_shipping_amount  = self.orderData.object(forKey: "base_shipping_amount") as? String {
                cell.shipAndHandVallab.text = base_shipping_amount
                cell.shipAndHandVallab.updateCurrency(str: base_shipping_amount)

            }
            if let base_tax_amount  = self.orderData.object(forKey: "base_tax_amount") as? String {
                cell.taxValLab.text = base_tax_amount
                cell.taxValLab.updateCurrency(str: base_tax_amount)

            }
            if let base_grand_total  = self.orderData.object(forKey: "base_grand_total") as? String {
                cell.grandTotalVallab.text = base_grand_total
                cell.grandTotalVallab.updateCurrency(str: base_grand_total)

            }
            if let base_total_paid  = self.orderData.object(forKey: "base_total_paid") as? String {
                cell.totalPaidValLab.text = base_total_paid
                cell.totalPaidValLab.updateCurrency(str: cell.totalPaidValLab.text!)

            }

            

        }
        cell.selectionStyle = .none

        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 160
//        }
//        else if indexPath.section == 1 {
//            return 120
//        }
//        else if indexPath.section == 2 {
//            return 170
//        }
//        else if indexPath.section == 3 {
//            return 170
//        }
//        else if indexPath.section == 4 {
//            return 98
//        }
//        else if indexPath.section == 5 {
//            return 91
//        }
//        else if indexPath.section == 6 {
//            if let items  = self.orderData.object(forKey: "items") as? NSArray {
//                if items.count == 1 {
//                    return 60
//                }
//            }
//
//            return 325
//        }
//        else if indexPath.section == 7 {
//            return 281
//        }
//        
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        headView.backgroundColor = ObjRef.sharedInstance.magentoOrange
        headView.tag = section
        headView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.headerTapped(gesture:))))
        
        let image = UIImage(named: "downWhite")
        
        let imageV = UIImageView(image: image)
        imageV.frame = CGRect(x: headView.frame.size.width - (image?.size.width)!*2, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        imageV.center = headView.center
        imageV.frame.origin.x = tableView.frame.size.width - (image?.size.width)!*2
        headView.addSubview(imageV)
        
        let labTitle = UILabel(frame: headView.frame)
        if section == 0 {
            labTitle.text = " ORDERS"
        }
        else if section == 1 {
            labTitle.text = " ACCOUNT INFORMATION"
        }
        else if section == 2 {
            labTitle.text = " BILLING ADDRESS"
        }
        else if section == 3 {
            labTitle.text = " SHIPPING ADDRESS"
        }
        else if section == 4 {
            labTitle.text = " PAYMENT INFORMATION"
        }
        else if section == 5 {
            labTitle.text = " SHIPPING & HANDLING"
        }
        else if section == 6 {
            labTitle.text = " ITEMS ORDERED"
        }
        else if section == 7 {
            labTitle.text = " ORDER TOTALS"
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
        
        orderDetailTableView.reloadData()
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
