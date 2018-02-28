
//
//  DashboardViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit
import SwiftCharts


class DashboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UUChartDataSource,SimpleBarChartDataSource, SimpleBarChartDelegate {
    

    var oldCellContentConstVal = Int()
    var dashboardDataDict = NSDictionary()
    var totalUser = Int()
    var totalOrder = Int()
    var imagesArr = NSArray()
    var initialDataLoaded = Bool()
    let sideSelectorHeight: CGFloat = 50
    var visitsGraphData = NSArray()
    var salesGraphData = NSArray()
    var visitsDictData = NSDictionary()
    var ordersChartData = NSArray()
    var ordersDictData = NSDictionary()
    var customersChartData = NSArray()
    var customersDictData = NSDictionary()
    var abandonedDictData = NSDictionary()

    var values = NSArray()
    
    @IBAction func menuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())
        
    }
    
    @IBOutlet var dashboardTableView: UITableView!
    
    let kHACPercentage  =    "percentage"
    let kHACColor       =     "color"
    let kHACCustomText  =     "customText"
    
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        
        APIManager.sharedInstance.getRequestWithId(appendParam: "dashboard/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ", presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        if let dataObj = responseData.object(forKey: "dataObject") as? NSDictionary {
                            self.dashboardDataDict = dataObj as! NSDictionary
                            self.initialDataLoaded = true
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.dashboardTableView.reloadData()
                            })
                        }
                    }
                    else {
                        self.initialDataLoaded = false

                        if let message = responseData.object(forKey: "message") as? String {
                            ObjRef.sharedInstance.showAlertController(msg: message, superVC: self)
                        }
                    }
                }
                else {
                    
                    
                }
            }
        }, onFailure: { (error) in
            

        })

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // var languageID = Bundle.main.preferredLocalizations
        self.title = NSLocalizedString("Dashboard", comment: "")
        
        if initialDataLoaded == false {
            self.reloadButtonTapped(UIButton())
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.dashboardTableView.reloadData()
            
        })

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
            }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.layoutIfNeeded()
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        ObjRef.sharedInstance.setupNavigationBar(vc: self)
        
        self.dashboardTableView.reloadData()
        
        //self.dashboardTableView.contentInset = UIEdgeInsetsMake((self.navigationController?.navigationBar.frame.size.height)!,0,0,0);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialDataLoaded = true
        values = [30, 45, 44, 50];
        
        self.title = "Dashboard"
        
        imagesArr = ["revenue_dash.png","totalVisit_dash.png","todayVisit_dash.png","last5order_dash.png","avgOrder.png","totalOrders.png","todayCustomer_dash.png","topsearch.png"]

        
        //APIManager.sharedInstance.getRequestWithId(appendParam: "", presentingView: self.view , onSuccess: (AnyObject) -> Void, onFailure: (Error) -> Void)
        
        //        APIManager.sharedInstance.postRequestWithId(appendParam: "", bodyData: "", presentingView: self.view, onSuccess: { (json) in
        //
        //
        //        }, onFailure: { (error) in
        //        })
        
        self.dashboardTableView.reloadData()
        
        
        self.getVisitFigureApi(UIButton())
        self.reloadSalesTapped(UIButton())
        self.getOrderFigureApi(UIButton())
        self.getCustomerFigureApi(UIButton())
        // Do any additional setup after loading the view.
    }
    @IBAction func getOrderFigureApi(_ sender: Any) {
        
        var viewS = self.view
        if (sender as! UIButton).superview == nil {
            viewS = self.view
        }
        else {
            viewS = ((sender as! UIButton).superview?.superview?.superview)
        }
        
        if (sender as! UIButton).tag == 4 {
            
            self.singleApiFunctionForAllFigures(paramStr: "orders=1&", loadingView: viewS!)
        }
        else {
            self.singleApiFunctionForAllFigures(paramStr: "customers=1&", loadingView: viewS!)
        }
    }
    @IBAction func getCustomerFigureApi(_ sender: Any) {//customers
        var viewS = self.view
        if (sender as! UIButton).superview == nil {
            viewS = self.view
        }
        else {
            viewS = ((sender as! UIButton).superview?.superview?.superview)
        }
        self.singleApiFunctionForAllFigures(paramStr: "customers=1&", loadingView: viewS!)
    }
    @IBAction func getVisitFigureApi(_ sender: Any) {
        
        var viewS = self.view
        if (sender as! UIButton).superview == nil {
            viewS = self.view
        }
        else {
            viewS = ((sender as! UIButton).superview?.superview?.superview)
        }
        self.singleApiFunctionForAllFigures(paramStr: "getVisitorsFront=1&", loadingView: viewS!)
    }
    
    @IBAction func reloadSalesTapped(_ sender: Any) {
        var viewS = self.view
        if (sender as! UIButton).superview == nil {
            viewS = self.view
        }
        else {
            viewS = ((sender as! UIButton).superview?.superview?.superview)
        }
        self.singleApiFunctionForAllFigures(paramStr: "sales_updated=1&", loadingView: viewS!)

    }
    func getSalesFigureApi() {

    }
    
    @IBAction func reloadAbandonedCartData(_ sender: Any) {
        
        var viewS = self.view
        if (sender as! UIButton).superview == nil {
            viewS = self.view
        }
        else {
            viewS = ((sender as! UIButton).superview?.superview?.superview)
        }
        self.singleApiFunctionForAllFigures(paramStr: "abandonedCart=1&", loadingView: viewS!)
        
    }
    
    func singleApiFunctionForAllFigures(paramStr : String,loadingView : UIView) {
        
        let postStr = paramStr + "token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&store_id=\(ObjRef.sharedInstance.storeIdSelected)"
        
        MBProgressHUD.showAdded(to: loadingView, animated: true)
        
        APIManager.sharedInstance.postRequestWithId(appendParam: "dashboard/getdata/", bodyData: postStr, presentingView: UIButton(), onSuccess: { (json) in
            
            DispatchQueue.main.async(execute: { () -> Void in
                MBProgressHUD.hide(for: loadingView, animated: true)
            })
            if let responseData = json as? NSDictionary {
                if let active = responseData.object(forKey: "status") as? String {
                    if active == "success" {
                        if let data = responseData.object(forKey: "data") as? NSArray {
                            if data.count > 0 {
                                if paramStr == "getVisitorsFront=1&" {
                                    self.visitsGraphData = data
                                }
                                else if paramStr == "orders=1&" {
                                    self.ordersChartData = data
                                }
                                else if paramStr == "customers=1&" {
                                    self.customersChartData = data
                                }
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    if paramStr == "getVisitorsFront=1&" {
                                        
                                        self.dashboardTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.none)
                                    }
                                    else if paramStr == "orders=1&" {
                                        self.dashboardTableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: UITableViewRowAnimation.none)
                                    }
                                    else if paramStr == "customers=1&" {
                                        self.dashboardTableView.reloadRows(at: [IndexPath(row: 8, section: 0)], with: UITableViewRowAnimation.none)
                                    }
                                })
                            }
                        }
                        if let data = responseData.object(forKey: "dataObject") as? NSDictionary {
                            if data.count > 0 {
                                if paramStr == "sales_updated=1&" {
                                    if let totals = data.object(forKey: "_totals") as? NSArray {
                                        self.salesGraphData = totals
                                    }
                                }
                                else if paramStr == "orders=1&" {
                                    self.ordersDictData = data
                                }
                                else if paramStr == "getVisitorsFront=1&" {
                                    self.visitsDictData = data
                                }
                                else if paramStr == "customers=1&" {
                                    self.customersDictData = data
                                }
                                else if paramStr == "abandonedCart=1&" {
                                    self.abandonedDictData = data
                                }
                                DispatchQueue.main.async(execute: { () -> Void in
                                    
                                    if paramStr == "sales_updated=1&" {
                                        //if let totals = data.object(forKey: "total") as? NSArray {
                                            self.dashboardTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.none)
                                       // }
                                    }
                                    else if paramStr == "orders=1&" {
                                        self.dashboardTableView.reloadRows(at: [IndexPath(row: 5, section: 0),IndexPath(row: 6, section: 0)], with: UITableViewRowAnimation.none)
                                    }
                                    else if paramStr == "getVisitorsFront=1&" {
                                        self.dashboardTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: UITableViewRowAnimation.none)
                                    }
                                    else if paramStr == "customers=1&" {
                                        self.dashboardTableView.reloadRows(at: [IndexPath(row: 9, section: 0),IndexPath(row: 10, section: 0)], with: UITableViewRowAnimation.none)
                                    }
                                    else if paramStr == "abandonedCart=1&" {
                                        self.dashboardTableView.reloadRows(at: [IndexPath(row: 7, section: 0)], with: UITableViewRowAnimation.none)
                                    }
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
            
        }) { (error) in
            DispatchQueue.main.async(execute: { () -> Void in
                MBProgressHUD.hide(for: loadingView, animated: true)
            })
        }
    }
    
    func removeDollarFromString(str : String) -> CGFloat {
        
        return CGFloat((str.replacingOccurrences(of: "$", with: "") as NSString).floatValue)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        cell.selectionStyle = .none

       // cell.contentView.frame.size.width = self.view.frame.size.width
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.viewAllButton.isHidden = true
        
        if indexPath.row >= 0 {//
            
            if indexPath.row == 1 {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellVisits") as! CustomTableViewCell
                cell.selectionStyle = .none

                cell.frame.size.width = tableView.frame.size.width
                cell.layoutIfNeeded()
                
                var updatedViewAdded = Bool()
                
                var viewIsPrsent = Bool()
                var oldView = AAChartView()
                for subview in cell.piechartSuperV.subviews {
                    if subview is AAChartView {
                        viewIsPrsent = true
                        oldView = subview as! AAChartView
                       // subview.removeFromSuperview()
                    }
                }

                var chartViewWidth  = tableView.frame.size.width*0.85;
                
                //var chartViewHeight = cell.visitChart.frame.size.width;
                var aaChartView = AAChartView()
                if viewIsPrsent == true {
                    aaChartView = oldView
                }
                //aaChartView.frame = CGRect(x: cell.visitChart.frame.origin.x, y: cell.visitChart.frame.origin.y, width: chartViewWidth, height: chartViewWidth)
                //aaChartView.center = cell.piechartSuperV.center
                aaChartView.frame = cell.visitChart.frame
                
               // aaChartView.center = cell.visitChart.center
                // set the content height of aachartView
                // aaChartView?.contentHeight = self.view.frame.size.height
                if viewIsPrsent == false {
                    cell.piechartSuperV.addSubview(aaChartView)
                }
                
                if self.visitsGraphData.count > 0 {
                    
                    let tueDict = (self.visitsGraphData.object(at: 0) as! NSDictionary)
                    let wedDict = (self.visitsGraphData.object(at: 1) as! NSDictionary)
                    let thuDict = (self.visitsGraphData.object(at: 2) as! NSDictionary)
                    let friDict = (self.visitsGraphData.object(at: 3) as! NSDictionary)
                    let satDict = (self.visitsGraphData.object(at: 4) as! NSDictionary)
                    let sunDict = (self.visitsGraphData.object(at: 5) as! NSDictionary)
                    let monDict = (self.visitsGraphData.object(at: 6) as! NSDictionary)

                    let Tue = tueDict.object(forKey: "day") as! String
                    let Wed = wedDict.object(forKey: "day") as! String
                    let Thu = thuDict.object(forKey: "day") as! String
                    let Fri = friDict.object(forKey: "day") as! String
                    let Sat = satDict.object(forKey: "day") as! String
                    let Sun = sunDict.object(forKey: "day") as! String
                    let Mon = monDict.object(forKey: "day") as! String
                    
                    let TueRev = removeDollarFromString(str: tueDict.object(forKey: "revenue") as! String)
                    let WedRev = removeDollarFromString(str: wedDict.object(forKey: "revenue") as! String)
                    let ThuRev = removeDollarFromString(str:thuDict.object(forKey: "revenue") as! String)
                    let FriRev = removeDollarFromString(str:friDict.object(forKey: "revenue") as! String)
                    let SatRev = removeDollarFromString(str:satDict.object(forKey: "revenue") as! String)
                    let SunRev = removeDollarFromString(str:sunDict.object(forKey: "revenue") as! String)
                    let MonRev = removeDollarFromString(str:monDict.object(forKey: "revenue") as! String)
                    
                    let TueVisit = tueDict.object(forKey: "visits") as! Int
                    let WedVisit = wedDict.object(forKey: "visits") as! Int
                    let ThuVisit = thuDict.object(forKey: "visits") as! Int
                    let FriVisit = friDict.object(forKey: "visits") as! Int
                    let SatVisit = satDict.object(forKey: "visits") as! Int
                    let SunVisit = sunDict.object(forKey: "visits") as! Int
                    let MonVisit = monDict.object(forKey: "visits") as! Int
                
                var aaChartModel = AAChartModel.init()
                    
                    .chartType(AAChartType.Area)//Can be any of the chart types listed under `AAChartType`.
                    .animationType(AAChartAnimationType.Bounce)
                    .title("TITLE")//The chart title
                    .subtitle("subtitle")//The chart subtitle
                    .dataLabelEnabled(false) //Enable or disable the data labels. Defaults to false
                    .tooltipValueSuffix("$")//the value suffix of the chart tooltip
                    
                    .categories([Tue,Wed,Thu,Fri,Sat,Sun,Mon])

                    .colorsTheme(["#A2A3A4","#ff5a20"])
                    .series([
                        [
                            "name": "Visit",
                            "step":false,
                            "data": [TueVisit, WedVisit, ThuVisit, FriVisit, SatVisit, SunVisit, MonVisit]
                        ], [
                            "name": "Revenue",
                            "step":false,
                            "data": [CGFloat(TueRev), CGFloat(WedRev), CGFloat(ThuRev), CGFloat(FriRev), CGFloat(SatRev), CGFloat(SunRev), CGFloat(MonRev)]
                        ]])
                    
                    cell.labRefS.text = "Visit"
                    cell.labNPF.text = "Revenue"

                    aaChartView.aa_drawChartWithChartModel(aaChartModel)
                    cell.piechartSuperV.bringSubview(toFront: cell.visitchartDetailView)
                }

                cell.colorRev.layer.cornerRadius = cell.colorRev.frame.size.width*0.5
                cell.colorVisit.layer.cornerRadius = cell.colorVisit.frame.size.width*0.5

                cell.colorRev.backgroundColor = PNColor1
                cell.colorVisit.backgroundColor = UIColor.gray

                self.updateCellFont(superV: cell.contentView)
                cell.barChartTitle.text = "Visits"
                //cell.barChartTitle.font = UIFont.boldSystemFont(ofSize: cell.barChartTitle.font.pointSize)

                cell.barChartTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.barChartTitle.font.fontName, fontSize: 15)

                /* */
                return cell
            }
            else if indexPath.row == 0 {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellPieChart") as! CustomTableViewCell
                cell.selectionStyle = .none

              //  cell.layoutSubviews()
                for subview in cell.piechartSuperV.subviews {
                    
                    if subview is PNPieChart {
                        subview.removeFromSuperview()
                    }
                }
                
                if salesGraphData.count > 0 {
                    
                    var dict1 = self.salesGraphData.object(at: 0) as! NSDictionary
                    var dict2 = self.salesGraphData.object(at: 1) as! NSDictionary
                    var dict3 = self.salesGraphData.object(at: 2) as! NSDictionary
                    var dict4 = self.salesGraphData.object(at: 3) as! NSDictionary

                    let name1 = dict1.object(forKey: "label") as! String
                    let name2 = dict2.object(forKey: "label") as! String
                    let name3 = dict3.object(forKey: "label") as! String
                    let name4 = dict4.object(forKey: "label") as! String

                    let val1 = removeDollarFromString(str: dict1.object(forKey: "value") as! String)
                    let val2 = removeDollarFromString(str: dict2.object(forKey: "value") as! String)
                    let val3 = removeDollarFromString(str: dict3.object(forKey: "value") as! String)
                    //let val4 = removeDollarFromString(str: dict4.object(forKey: "value") as! String)

                    let item1 = PNPieChartDataItem(dateValue: CGFloat(val1), dateColor:  PNColor1, description: name1)
                    let item2 = PNPieChartDataItem(dateValue: CGFloat(val2), dateColor: PNColor2, description: name2)
                    let item3 = PNPieChartDataItem(dateValue: CGFloat(val3), dateColor: PNColor3, description: name3)
                    let item4 = PNPieChartDataItem(dateValue: CGFloat(0), dateColor: PNColor4, description: name4)
                    
                    var chartViewWidth  = tableView.frame.size.width*0.85*0.5;
                    if cell.pieChartView.frame.size.width > cell.pieChartView.frame.size.height {
                        chartViewWidth  = cell.pieChartView.frame.size.height;
                    }
                    // var chartViewHeight = tableView.frame.size.width*0.85*0.5;
                    var aaChartView = AAChartView()
                    let frame = CGRect(x: cell.pieChartView.frame.origin.x, y: cell.pieChartView.frame.origin.y, width: chartViewWidth, height: chartViewWidth)
                    //cell.pieChartView.frame = frame
                    
                    let items: [PNPieChartDataItem] = [item1, item2, item3,item4]
                    let pieChart = PNPieChart(frame: frame, items: items)
                    //pieChart.descriptionTextColor = UIColor.white
                    //pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14)!
                    //pieChart.center.y = cell.piechartSuperV.center.y
                    //pieChart.frame.origin.x = 30
                    //pieChart.frame.origin.y = cell.pieChartView.frame.origin.y
                    cell.piechartSuperV.addSubview(pieChart)
                    pieChart.frame = frame
                    pieChart.center.y = cell.piechartSuperV.frame.size.height*0.5
                    
                    cell.labNPF.text = name1
                    cell.labRefS.text = name2
                    cell.labShip.text = name3
                    cell.labTax.text = name4
                    
                    cell.labNPVF.text = "\(val1)"
                    cell.labRefVS.text = "\(val2)"
                    cell.labShipVal.text = "\(val3)"
                    cell.labTaxVal.text = "0"
                    
                    
                    cell.colorNP.backgroundColor = PNColor1
                    cell.colorRef.backgroundColor = PNColor2
                    cell.colorShip.backgroundColor = PNColor3
                    cell.colorTax.backgroundColor = PNColor4
                    
                    cell.colorNP.layer.cornerRadius = cell.colorNP.frame.size.width*0.5
                    cell.colorRef.layer.cornerRadius = cell.colorRef.frame.size.width*0.5
                    cell.colorTax.layer.cornerRadius = cell.colorTax.frame.size.width*0.5
                    cell.colorShip.layer.cornerRadius = cell.colorShip.frame.size.width*0.5
                }

                cell.barChartTitle.text = "Sales Overview"
                
                self.updateCellFont(superV: cell.contentView)

                cell.labNPVF.isHidden = false
                cell.labRefVS.isHidden = false
                cell.labShipVal.isHidden = false
                cell.labTaxVal.isHidden = false
                
                cell.labNPVPF.isHidden = false
                cell.labRefVPS.isHidden = false
                cell.labShipValP.isHidden = false
                cell.labTaxValP.isHidden = false
                cell.barChartTitle.text = "Sales Overview"
               // cell.barChartTitle.font = UIFont.boldSystemFont(ofSize: cell.barChartTitle.font.pointSize)

                cell.barChartTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.barChartTitle.font.fontName, fontSize: 15)

                return cell
                

                /**/
            }
            else if indexPath.row == 2 {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellVisitsVal") as! CustomTableViewCell
                cell.selectionStyle = .none

                if visitsDictData.count > 0 {
                    cell.todayVisitLab.text = "Today's Visits"
                    if let strToday = self.visitsDictData.object(forKey: "today_visits") as? Int {
                        cell.todayVisitValLab.text = "\(strToday)"
                    }
                    cell.todayRevLab.text = "Today's Revenue"
                    if let strToday = self.visitsDictData.object(forKey: "today_revenue") as? String {
                        cell.todayRevValLab.text = strToday
                    }
                    
                    cell.weekVisitLab.text = "This Week Visits"
                    if let strToday = self.visitsDictData.object(forKey: "week_visits") as? Int {
                        cell.weekVisitVallab.text = "\(strToday)"
                    }
                    
                    cell.weekRevLab.text = "This Week Revenue"
                    if let strToday = self.visitsDictData.object(forKey: "week_revenue") as? String {
                        cell.weekRevValLab.text = strToday
                    }
                }
                self.updateCellFont(superV: cell.contentView)


                return cell
                
            }
            else if indexPath.row == 3 {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellPieChart", for: indexPath) as! CustomTableViewCell
                
                cell.selectionStyle = .none

                for subview in cell.piechartSuperV.subviews {
                    
                    if subview is PNPieChart {
                        subview.removeFromSuperview()
                    }
                    
                }
                
                let item1 = PNPieChartDataItem(dateValue: 20, dateColor:  PNColor1, description: "Build")
                let item2 = PNPieChartDataItem(dateValue: 20, dateColor: PNColor2, description: "I/O")
                let item3 = PNPieChartDataItem(dateValue: 45, dateColor: PNColor3, description: "WWDC")
                let item4 = PNPieChartDataItem(dateValue: 30, dateColor: PNColor4, description: "WWDC")
                
                var chartViewWidth  = tableView.frame.size.width*0.85*0.5;
                if cell.pieChartView.frame.size.width > cell.pieChartView.frame.size.height {
                    chartViewWidth  = cell.pieChartView.frame.size.height;
                }
                // var chartViewHeight = tableView.frame.size.width*0.85*0.5;
                var aaChartView = AAChartView()
                let frame = CGRect(x: cell.pieChartView.frame.origin.x, y: cell.pieChartView.frame.origin.y, width: chartViewWidth, height: chartViewWidth)
                
            
                //cell.pieChartView.frame = frame
                //cell.pieChartView.center.y = cell.pieChartDiscView.center.y
                
                let items: [PNPieChartDataItem] = [item1, item2, item3,item4]
                let pieChart = PNPieChart(frame: frame, items: items)
                //pieChart.descriptionTextColor = UIColor.white
                //pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14)!
                //pieChart.center.y = cell.piechartSuperV.center.y
                //pieChart.frame.origin.x = 30
                //pieChart.frame.origin.y = cell.pieChartView.frame.origin.y
                cell.piechartSuperV.addSubview(pieChart)
                pieChart.frame = frame
                pieChart.center.y = cell.piechartSuperV.frame.size.height*0.5
                cell.colorNP.backgroundColor = PNColor1
                cell.colorRef.backgroundColor = PNColor2
                cell.colorShip.backgroundColor = PNColor3
                cell.colorTax.backgroundColor = PNColor4
                
                cell.colorNP.layer.cornerRadius = cell.colorNP.frame.size.width*0.5
                cell.colorRef.layer.cornerRadius = cell.colorRef.frame.size.width*0.5
                cell.colorTax.layer.cornerRadius = cell.colorTax.frame.size.width*0.5
                cell.colorShip.layer.cornerRadius = cell.colorShip.frame.size.width*0.5
                
                cell.barChartTitle.text = "Sales Overview"
                
//                cell.piePercentWidth1.constant = 0
//                cell.piePercentWidth2.constant = 0
//                cell.piePercentWidth3.constant = 0
//                cell.piePercentWidth4.constant = 0

                cell.labNPVF.isHidden = true
                cell.labRefVS.isHidden = true
                cell.labShipVal.isHidden = true
                cell.labTaxVal.isHidden = true

                cell.labNPVPF.isHidden = true
                cell.labRefVPS.isHidden = true
                cell.labShipValP.isHidden = true
                cell.labTaxValP.isHidden = true

                self.updateCellFont(superV: cell.contentView)

                cell.barChartTitle.text = "Visits by Channels"
                //cell.barChartTitle.font = UIFont.boldSystemFont(ofSize: cell.barChartTitle.font.pointSize)

                cell.barChartTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.barChartTitle.font.fontName, fontSize: 15)

                return cell
                
                /**/
            }
            else if indexPath.row == 4 {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderChart") as! CustomTableViewCell
                cell.selectionStyle = .none

                for subview in cell.piechartSuperV.subviews {
                    
                    if subview is ChartView {
                        subview.removeFromSuperview()
                    }
                }
                if indexPath.row == 11 {
                    cell.barChartTitle.text = "LAST 4 YEARS VISITORS"
                }
                cell.reloadButton.tag = indexPath.row

                let chart = self.chart(horizontal: false, superV: cell.visitChart, cellTag: indexPath.row )
                chart.view.isUserInteractionEnabled = false

                cell.piechartSuperV.addSubview(chart.view)
                cell.chart = chart
                
                cell.colorNP.backgroundColor = UIColor.gray
                cell.colorRef.backgroundColor = ObjRef.sharedInstance.magentoOrange
                cell.colorShip.backgroundColor = UIColor.black
                
                cell.colorNP.layer.cornerRadius = cell.colorNP.frame.size.width*0.5
                cell.colorRef.layer.cornerRadius = cell.colorRef.frame.size.width*0.5
                cell.colorShip.layer.cornerRadius = cell.colorShip.frame.size.width*0.5

                self.updateCellFont(superV: cell.contentView)

                cell.barChartTitle.text = "Orders"
                //cell.barChartTitle.font = UIFont.boldSystemFont(ofSize: cell.barChartTitle.font.pointSize)

                cell.barChartTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.barChartTitle.font.fontName, fontSize: 15)

                return cell
                
                /**/
            }
            else if indexPath.row == 5 {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellVisitsVal") as! CustomTableViewCell
                cell.selectionStyle = .none

                cell.todayVisitLab.text = "Today's Visits"
                cell.todayVisitValLab.text = "$5000"
                
                cell.todayRevLab.text = "Today's Revenue"
                cell.todayRevValLab.text = "$5000"
                
                cell.weekVisitLab.text = "This Week Visits"
                cell.weekVisitVallab.text = "$5000"
                
                cell.weekRevLab.text = "This Week Revenue"
                cell.weekRevValLab.text = "$5000"
                
                if ordersDictData.count > 0 {
                    cell.todayVisitLab.text = "Today's Visits"
                    if let strToday = self.ordersDictData.object(forKey: "today_orders") as? Int {
                        cell.todayVisitValLab.text = "\(strToday)"
                    }
                    cell.todayRevLab.text = "Today's Revenue"
                    if let strToday = self.ordersDictData.object(forKey: "today_revenue") as? String {
                        cell.todayRevValLab.text = strToday
                    }
                    
                    cell.weekVisitLab.text = "This Week Visits"
                    if let strToday = self.ordersDictData.object(forKey: "week_orders") as? Int {
                        cell.weekVisitVallab.text = "\(strToday)"
                    }
                    
                    cell.weekRevLab.text = "This Week Revenue"
                    if let strToday = self.ordersDictData.object(forKey: "week_revenue") as? String {
                        cell.weekRevValLab.text = strToday
                    }
                }
                self.updateCellFont(superV: cell.contentView)

                
                return cell
                
                /**/
            }
            else if indexPath.row == 6 {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderVal") as! CustomTableViewCell
                cell.selectionStyle = .none

                cell.todayVisitLab.text = "Average Orders"
                cell.todayVisitValLab.text = "$5000"
                
                cell.todayRevLab.text = "Average Orders Revenue"
                cell.todayRevValLab.text = "$5000"
                
                if ordersDictData.count > 0 {
                    if let strToday = self.ordersDictData.object(forKey: "week_order_average") as? NSNumber {
                        cell.todayVisitValLab.text = "\(strToday)"
                    }
                    if let strToday = self.ordersDictData.object(forKey: "week_revenue_average") as? String {
                        cell.todayRevValLab.text = strToday
                    }
                }
                self.updateCellFont(superV: cell.contentView)

                
                return cell
                
                /**/
            }
            else if indexPath.row == 7 {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellAbandoned") as! CustomTableViewCell
                cell.selectionStyle = .none

                self.updateCellFont(superV: cell.contentView)
                cell.barChartTitle.text = "Abandoned Cart"
                //cell.barChartTitle.font = UIFont.boldSystemFont(ofSize: cell.barChartTitle.font.pointSize)

                //{"abandoned_carts":11,"abandoned_revenue":"$8,603.79","abandoned_revenue_percentage":"7.2974519617215%"}
                
                if let abandonedVal = self.abandonedDictData.object(forKey: "abandoned_carts") as? NSNumber {
                    cell.abandonedCartLab.text = "\(abandonedVal)"
                }
//                if let abandonedValPerc = self.abandonedDictData.object(forKey: "abandoned_carts") as? String {
//                    cell.abandonedCartValLab.text = abandonedValPerc
//                }
                if let abandoned_revenue = self.abandonedDictData.object(forKey: "abandoned_revenue") as? String {
                    cell.abandonedRevlab.text = abandoned_revenue
                }
                if let abandoned_revenue_percentage = self.abandonedDictData.object(forKey: "abandoned_revenue_percentage") as? String {
                    cell.abandonedRevVallab.text = abandoned_revenue_percentage
                }
                
                cell.barChartTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.barChartTitle.font.fontName, fontSize: 15)

                cell.abandonedRevlab.font = ObjRef.sharedInstance.updateFont(fontName: cell.abandonedRevlab.font.fontName, fontSize: 13)
                cell.abandonedCartLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.abandonedCartLab.font.fontName, fontSize: 13)

                return cell
                
                /**/
            }
            else if indexPath.row == 8 {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderChart") as! CustomTableViewCell
                cell.selectionStyle = .none

                for subview in cell.piechartSuperV.subviews {
                    
                    if subview is ChartView {
                        subview.removeFromSuperview()
                    }
                }
                if indexPath.row == 11 {
                    cell.barChartTitle.text = "LAST 4 YEARS VISITORS"
                }
               
                let chart = self.chart(horizontal: false, superV: cell.visitChart, cellTag: indexPath.row)
                chart.view.isUserInteractionEnabled = false
                cell.reloadButton.tag = indexPath.row
                
                cell.piechartSuperV.addSubview(chart.view)
                cell.chart = chart
                
                cell.colorNP.backgroundColor = UIColor.gray
                cell.colorRef.backgroundColor = ObjRef.sharedInstance.magentoOrange
                cell.colorShip.backgroundColor = UIColor.black
                
                cell.colorNP.layer.cornerRadius = cell.colorNP.frame.size.width*0.5
                cell.colorRef.layer.cornerRadius = cell.colorRef.frame.size.width*0.5
                cell.colorShip.layer.cornerRadius = cell.colorShip.frame.size.width*0.5

                self.updateCellFont(superV: cell.contentView)
                cell.barChartTitle.text = "Customers"
                //cell.barChartTitle.font = UIFont.boldSystemFont(ofSize: cell.barChartTitle.font.pointSize)
                
                cell.barChartTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.barChartTitle.font.fontName, fontSize: 15)

                return cell
                
                /**/
            }
            else if indexPath.row == 9 {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellVisitsVal") as! CustomTableViewCell
                cell.selectionStyle = .none

                cell.todayVisitLab.text = "Today's Visits"
                cell.todayVisitValLab.text = "$5000"
                
                cell.todayRevLab.text = "Today's Revenue"
                cell.todayRevValLab.text = "$5000"
                
                cell.weekVisitLab.text = "This Week Visits"
                cell.weekVisitVallab.text = "$5000"
                
                cell.weekRevLab.text = "This Week Revenue"
                cell.weekRevValLab.text = "$5000"
                
                if customersDictData.count > 0 {
                    cell.todayVisitLab.text = "Today's Visits"
                    if let strToday = self.customersDictData.object(forKey: "today_customers") as? Int {
                        cell.todayVisitValLab.text = "\(strToday)"
                    }
                    cell.todayRevLab.text = "Today's Revenue"
                    if let strToday = self.customersDictData.object(forKey: "today_revenue") as? String {
                        cell.todayRevValLab.text = strToday
                    }
                    
                    cell.weekVisitLab.text = "This Week Visits"
                    if let strToday = self.customersDictData.object(forKey: "week_customers") as? Int {
                        cell.weekVisitVallab.text = "\(strToday)"
                    }
                    
                    cell.weekRevLab.text = "This Week Revenue"
                    if let strToday = self.customersDictData.object(forKey: "week_revenue") as? String {
                        cell.weekRevValLab.text = strToday
                    }
                }
                self.updateCellFont(superV: cell.contentView)

                
                return cell
                
                /**/
            }
            else if indexPath.row == 10 {
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: "cellOrderVal") as! CustomTableViewCell
                cell.selectionStyle = .none

                cell.todayVisitLab.text = "Average Customers"
                cell.todayVisitValLab.text = "$5000"
                
                cell.todayRevLab.text = "Average Customers Revenue"
                cell.todayRevValLab.text = "$5000"
                
                if customersDictData.count > 0 {
                    if let strToday = self.customersDictData.object(forKey: "week_customer_average") as? NSNumber {
                        cell.todayVisitValLab.text = "\(strToday)"
                    }
                    if let strToday = self.customersDictData.object(forKey: "week_revenue_average") as? String {
                        cell.todayRevValLab.text = strToday
                    }
                }
                self.updateCellFont(superV: cell.contentView)
                
                return cell
                
                /**/
            }
            
        }
            
        
            
        else if indexPath.row == 0 {
            cell.selectionStyle = .none

            cell.cellTitle.text = "Total Revenue"
            if self.dashboardDataDict.count > 0 {
                cell.cellTitleVal.text = self.dashboardDataDict["totalRevenue"] as? String
            }
            if oldCellContentConstVal > 0 {
                cell.cellTitleValWidthConst.constant = CGFloat(oldCellContentConstVal)
            }
            else {
                oldCellContentConstVal = Int(cell.cellTitleValWidthConst.constant)
            }
            
        }
        else if indexPath.row == 1 {
            cell.cellTitle.text = "Total Visits"
            if self.dashboardDataDict.count > 0 {
                
                cell.cellTitleVal.text = "\(self.dashboardDataDict["totalVisits"]!)"
            }
        }
        else if indexPath.row == 2 {
            cell.cellTitle.text = "Today's Visits"
            if self.dashboardDataDict.count > 0 {
                
                cell.cellTitleVal.text = "\(self.dashboardDataDict["todayVisits"]!)"
            }
        }
        else if indexPath.row == 3{
            cell.cellTitle.text = "Last 5 Orders"
            if self.dashboardDataDict.count > 0 {
                
                cell.cellTitleVal.text = "\(self.dashboardDataDict["last5order"]!)"
            }
        }
        else if indexPath.row == 4 {
            cell.cellTitle.text = "Average Orders"
            if self.dashboardDataDict.count > 0 {
                
                cell.cellTitleVal.text = "\(self.dashboardDataDict["avg_order"]!)"
            }
        }
        else if indexPath.row == 5 {
            cell.cellTitle.text = "Total Orders"
            cell.viewAllButton.isHidden = false
            if self.dashboardDataDict.count > 0 {
                
                cell.cellTitleVal.text = "\(self.dashboardDataDict["total_orders"]!)"
                totalOrder = Int((self.dashboardDataDict["total_orders"]! as! NSString).intValue)

            }
            cell.selectionStyle = .default

        }
        else if indexPath.row == 6 {
            cell.cellTitle.text = "Total Users"
            cell.viewAllButton.isHidden = false
            if self.dashboardDataDict.count > 0 {
                
                cell.cellTitleVal.text = "\(self.dashboardDataDict["totalUsers"]!)"
                totalUser = self.dashboardDataDict["totalUsers"]! as! Int
            }
            cell.selectionStyle = .default

        }
        else if indexPath.row == 7 {
            cell.cellTitle.text = "Top 5 Search Terms"
            cell.viewAllButton.isHidden = false
            cell.cellTitleVal.isHidden = true
            cell.cellTitleValWidthConst.constant = 0
            cell.selectionStyle = .default
            cell.selectionStyle = .default
        }
        if indexPath.row < 7 {
            cell.cellTitleVal.isHidden = false
            
        }
        if indexPath.row <= 7 {
            let imageName = self.imagesArr.object(at: indexPath.row) as! String
            cell.cellImage.image = UIImage(named: imageName)
            
            let fontSize = 14
            
            cell.cellTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.cellTitle.font.fontName, fontSize: fontSize)
            
            cell.cellTitleVal.font = ObjRef.sharedInstance.updateFont(fontName: cell.cellTitleVal.font.fontName, fontSize: fontSize)
            cell.viewAllButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: cell.cellTitleVal.font.fontName, fontSize: fontSize - 2)
            
            if cell.viewAllButton.isHidden == true {
                cell.selectionStyle = .none
            }
            else {
                cell.selectionStyle = .default
            }
        }
        else {
            cell.selectionStyle = .none
        }
        
        
        
        return cell
    }
    func updateCellFont(superV:UIView){
        //return
        for subV in superV.subviews {
            if subV is UILabel {//
                (subV as! UILabel).font = ObjRef.sharedInstance.updateFont(fontName: (subV as! UILabel).font.fontName, fontSize: 11)
                //(subV as! UILabel).font = UIFont.preferredFont(forTextStyle: UIFontTextStyleBody)
            }
            else if subV is UIButton {
                (subV as! UIButton).titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: ((subV as! UIButton).titleLabel?.font.fontName)!, fontSize: 10)
            }
            else if subV is UIView {
                self.updateCellFont(superV: subV)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8 {//
            return 265
        }
        else if indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 6 {//
            return 75
        }
        
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            
        }
        else if indexPath.row == 1 {
            
        }
        else {
            
        }
        
        if indexPath.row == 5 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController4 = storyboard.instantiateViewController(withIdentifier: "ViewController4Internal") as! OrderViewController
            viewController4.totalOrders = totalOrder
            
            self.navigationController?.pushViewController(viewController4, animated: true)
        }
        else if indexPath.row == 6 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController3 = storyboard.instantiateViewController(withIdentifier: "MoreMessageSegue") as! CustomerIntViewController
            viewController3.totalCustomer = totalUser
            self.navigationController?.pushViewController(viewController3, animated: true)
            
        }
        else if indexPath.row == 7 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchTermSegue") as! SearchTermViewController
            if self.dashboardDataDict.count > 0 {
                vc.top5SearchArr = self.dashboardDataDict["top5search"] as! NSArray
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    //UUChart data soucrce
    
    /*
     - (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
     {
     
     if (path.section==0) {
     switch (path.row) {
     case 0:
     return [self getXTitles:5];
     case 1:
     return [self getXTitles:11];
     case 2:
     return [self getXTitles:7];
     case 3:
     return [self getXTitles:7];
     default:
     break;
     }
     }else{
     switch (path.row) {
     case 0:
     return [self getXTitles:11];
     case 1:
     return [self getXTitles:7];
     default:
     break;
     }
     }
     return [self getXTitles:20];
     }
     //数值多重数组
     - (NSArray *)chartConfigAxisYValue:(UUChart *)chart
     {
     NSArray *ary = @[@"22",@"44",@"15",@"40",@"42"];
     NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42",@"77",@"43"];
     NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16",@"32",@"17"];
     NSArray *ary3 = @[@"3",@"12",@"25",@"55",@"52"];
     NSArray *ary4 = @[@"23",@"42",@"25",@"15",@"30",@"42",@"32",@"40",@"42",@"25",@"33"];
     
     if (path.section==0) {
     
     switch (path.row) {
     case 0:
     return @[ary];
     case 1:
     return @[ary4];
     case 2:
     return @[ary1,ary2];
     default:
     return @[ary1,ary2,ary3];
     }
     
     }else{
     if (path.row) {
     return @[ary1,ary2];
     }else{
     return @[ary4];
     }
     }
     }
     */
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 20))
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func chart(horizontal: Bool,superV : UIView,cellTag : Int) -> Chart {
        
        let labelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 13))
        let alpha: CGFloat = 0.8
        
        let color0 = ObjRef.sharedInstance.magentoOrange.withAlphaComponent(alpha)
        let color1 = UIColor.gray.withAlphaComponent(alpha)
        let color2 = UIColor.red.withAlphaComponent(alpha)
        let color3 = UIColor.green.withAlphaComponent(alpha)
        
        let zero = ChartAxisValueDouble(0)
        
        var name1 = String()
        var name2 = String()
        var name3 = String()
        var name4 = String()
        var name5 = String()
        var name6 = String()
        var name7 = String()
        
        var val1 = Int()
        var val2 = Int()
        var val3 = Int()
        var val4 = Int()
        var val5 = Int()
        var val6 = Int()
        var val7 = Int()
        
        var val11 = CGFloat()
        var val21 = CGFloat()
        var val31 = CGFloat()
        var val41 = CGFloat()
        var val51 = CGFloat()
        var val61 = CGFloat()
        var val71 = CGFloat()
        
        if (ordersChartData.count > 0 && cellTag == 4) || (customersChartData.count > 0 && cellTag == 8) {
            
            var dict1 = NSDictionary()
            var dict2 = NSDictionary()
            var dict3 = NSDictionary()
            var dict4 = NSDictionary()
            var dict5 = NSDictionary()
            var dict6 = NSDictionary()
            var dict7 = NSDictionary()
            
            if cellTag == 8 {
                dict1 = self.customersChartData.object(at: 0) as! NSDictionary
                dict2 = self.customersChartData.object(at: 1) as! NSDictionary
                dict3 = self.customersChartData.object(at: 2) as! NSDictionary
                dict4 = self.customersChartData.object(at: 3) as! NSDictionary
                dict5 = self.customersChartData.object(at: 4) as! NSDictionary
                dict6 = self.customersChartData.object(at: 5) as! NSDictionary
                dict7 = self.customersChartData.object(at: 6) as! NSDictionary
            }
            else {
                dict1 = self.ordersChartData.object(at: 0) as! NSDictionary
                dict2 = self.ordersChartData.object(at: 1) as! NSDictionary
                dict3 = self.ordersChartData.object(at: 2) as! NSDictionary
                dict4 = self.ordersChartData.object(at: 3) as! NSDictionary
                dict5 = self.ordersChartData.object(at: 4) as! NSDictionary
                dict6 = self.ordersChartData.object(at: 5) as! NSDictionary
                dict7 = self.ordersChartData.object(at: 6) as! NSDictionary
                
            }
            name1 = dict1.object(forKey: "day") as! String
            name2 = dict2.object(forKey: "day") as! String
            name3 = dict3.object(forKey: "day") as! String
            name4 = dict4.object(forKey: "day") as! String
            name5 = dict5.object(forKey: "day") as! String
            name6 = dict6.object(forKey: "day") as! String
            name7 = dict7.object(forKey: "day") as! String
            
            val11 = removeDollarFromString(str: dict1.object(forKey: "revenue") as! String)
            val21 = removeDollarFromString(str: dict2.object(forKey: "revenue") as! String)
            val31 = removeDollarFromString(str: dict3.object(forKey: "revenue") as! String)
            val41 = removeDollarFromString(str: dict4.object(forKey: "revenue") as! String)
            val51 = removeDollarFromString(str: dict4.object(forKey: "revenue") as! String)
            val61 = removeDollarFromString(str: dict4.object(forKey: "revenue") as! String)
            val71 = removeDollarFromString(str: dict4.object(forKey: "revenue") as! String)
            
            if cellTag == 4 {
                val1 = dict1.object(forKey: "order") as! Int
                val2 = dict2.object(forKey: "order") as! Int
                val3 = dict3.object(forKey: "order") as! Int
                val4 = dict4.object(forKey: "order") as! Int
                val5 = dict4.object(forKey: "order") as! Int
                val6 = dict4.object(forKey: "order") as! Int
                val7 = dict4.object(forKey: "order") as! Int
                
            }
            else {
                val1 = dict1.object(forKey: "customers") as! Int
                val2 = dict2.object(forKey: "customers") as! Int
                val3 = dict3.object(forKey: "customers") as! Int
                val4 = dict4.object(forKey: "customers") as! Int
                val5 = dict4.object(forKey: "customers") as! Int
                val6 = dict4.object(forKey: "customers") as! Int
                val7 = dict4.object(forKey: "customers") as! Int
            }
        }
        
        let barModels = [
            ChartStackedBarModel(constant: ChartAxisValueString(name1, order: 1, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double(val1), bgColor: color0),
                ChartStackedBarItemModel(quantity: Double(val11), bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name2, order: 2, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double(val2), bgColor: color0),
                ChartStackedBarItemModel(quantity: Double(val21), bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name3, order: 3, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double(val3), bgColor: color0),
                ChartStackedBarItemModel(quantity: Double(val31), bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name4, order: 4, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double(val4), bgColor: color0),
                ChartStackedBarItemModel(quantity: Double(val41), bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name5, order: 5, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double(val5), bgColor: color0),
                ChartStackedBarItemModel(quantity: Double(val51), bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name6, order: 6, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double(val6), bgColor: color0),
                ChartStackedBarItemModel(quantity: Double(val61), bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name7, order: 7, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: Double(val7), bgColor: color0),
                ChartStackedBarItemModel(quantity: Double(val71), bgColor: color1)
                ])
        ]
        
        let (axisValues1, axisValues2) = (
            stride(from: 0, through: 150, by: 20).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
            [ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + barModels.map{$0.constant} + [ChartAxisValueString("", order: 8, labelSettings: labelSettings)]
        )
        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        
        let frame = ExamplesDefaults.chartFrame(superV.bounds)
        let chartFrame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width*0.9), height: ((superV.superview?.frame.size.height)!))

        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let barViewSettings = ChartBarViewSettings(animDuration: 0.5)
        
        let chartStackedBarsLayer = ChartStackedBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, innerFrame: innerFrame, barModels: barModels, horizontal: horizontal, barWidth: 15, settings: barViewSettings, stackFrameSelectionViewUpdater: ChartViewSelectorAlpha(selectedAlpha: 1, deselectedAlpha: alpha)) {tappedBar in
            
            guard let stackFrameData = tappedBar.stackFrameData else {return}
            
            let chartViewPoint = tappedBar.layer.contentToGlobalCoordinates(CGPoint(x: tappedBar.barView.frame.midX, y: stackFrameData.stackedItemViewFrameRelativeToBarParent.minY))!
            let viewPoint = CGPoint(x: chartViewPoint.x, y: chartViewPoint.y + 70)
            let infoBubble = InfoBubble(point: viewPoint, preferredSize: CGSize(width: 50, height: 40), superview: self.view, text: "\(stackFrameData.stackedItemModel.quantity)", font: ExamplesDefaults.labelFont, textColor: UIColor.white, bgColor: UIColor.black)
            infoBubble.tapHandler = {
                infoBubble.removeFromSuperview()
            }
            superV.addSubview(infoBubble)
        }
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        return Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartStackedBarsLayer
            ]
        )
    }
    
    class DirSelector: UIView {
        
        let horizontal: UIButton
        let vertical: UIButton
        
        weak var controller: StackedBarsExample?
        
        fileprivate let buttonDirs: [UIButton : Bool]
        
        init(frame: CGRect, controller: StackedBarsExample) {
            
          ///  self.controller = controller
            
            self.horizontal = UIButton()
            self.horizontal.setTitle("Horizontal", for: UIControlState())
            self.vertical = UIButton()
            self.vertical.setTitle("Vertical", for: UIControlState())
            
            self.buttonDirs = [horizontal: true, vertical: false]
            
            super.init(frame: frame)
            
            addSubview(horizontal)
            addSubview(vertical)
            
            for button in [horizontal, vertical] {
                button.titleLabel?.font = ExamplesDefaults.fontWithSize(14)
                button.setTitleColor(UIColor.blue, for: UIControlState())
                button.addTarget(self, action: #selector(DirSelector.buttonTapped(_:)), for: .touchUpInside)
            }
        }
        
        @objc func buttonTapped(_ sender: UIButton) {
            let horizontal = sender == self.horizontal ? true : false
            //controller?.showChart(horizontal: horizontal)
        }
        
        override func didMoveToSuperview() {
            let views = [horizontal, vertical]
            for v in views {
                v.translatesAutoresizingMaskIntoConstraints = false
            }
            
            let namedViews = views.enumerated().map{index, view in
                ("v\(index)", view)
            }
            
            var viewsDict = Dictionary<String, UIView>()
            for namedView in namedViews {
                viewsDict[namedView.0] = namedView.1
            }
            
            let buttonsSpace: CGFloat = Env.iPad ? 20 : 10
            
            let hConstraintStr = namedViews.reduce("H:|") {str, tuple in
                "\(str)-(\(buttonsSpace))-[\(tuple.0)]"
            }
            
            let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraints(withVisualFormat: "V:|[\($0.0)]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)}
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hConstraintStr, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)
                + vConstraits)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    //MARK: bar chart delegaet
    
    func numberOfBars(in barChart: SimpleBarChart!) -> UInt {
        return 4
    }
    func barChart(_ barChart: SimpleBarChart!, valueForBarAt index: UInt) -> CGFloat {
        
        if self.dashboardDataDict.count == 0 {
            return 0
        }
        
        if barChart.tag == 11 {
            let year = self.dashboardDataDict["year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            
            return dict.value(forKey: "value")! as! CGFloat
        }
        
        let month = self.dashboardDataDict["month"] as! NSArray
        let dict = month.object(at: Int(index)) as! NSDictionary
        
        return dict.value(forKey: "value")! as! CGFloat
    }
    func barChart(_ barChart: SimpleBarChart!, textForBarAt index: UInt) -> String! {
        if self.dashboardDataDict.count == 0 {
            return ""
        }
        
        if barChart.tag == 11 {
            let year = self.dashboardDataDict["year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            
            
            return "\(dict.value(forKey: "value")!)"
        }
        
        let month = self.dashboardDataDict["month"] as! NSArray
        let dict = month.object(at: Int(index)) as! NSDictionary
        
        
        return "\(dict.value(forKey: "value")!)"

    }
   
    func barChart(_ barChart: SimpleBarChart!, xLabelForBarAt index: UInt) -> String! {
        if self.dashboardDataDict.count == 0 {
            return ""
        }
        
        if barChart.tag == 11 {
            let year = self.dashboardDataDict["year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            
            
            return "\(dict.value(forKey: "name")!)"
        }
        
        let month = self.dashboardDataDict["month"] as! NSArray
        let dict = month.object(at: Int(index)) as! NSDictionary
        
        
        return ("\(dict.value(forKey: "name")!)" as NSString).substring(to: 3)
    }
    
    func barChart(_ barChart: SimpleBarChart!, colorForBarAt index: UInt) -> UIColor! {
        if barChart.tag == 11 {
            return ObjRef.sharedInstance.magentoOrange
        }
        return ObjRef.sharedInstance.magentoGreen
    }
    
    func chartConfigAxisXLabel(_ chart: UUChart!) -> [Any]! {
        
        if self.dashboardDataDict.count == 0 {
            return ["","","",""]
        }
        
        if chart.tag == 9 {
            let year = self.dashboardDataDict["year"] as! NSArray
            let dict = year.object(at: 0) as! NSDictionary
            let dict2 = year.object(at: 1) as! NSDictionary
            let dict3 = year.object(at: 2) as! NSDictionary
            let dict4 = year.object(at: 3) as! NSDictionary
            
            return ["\(dict.value(forKey: "name")!)","\(dict2.value(forKey: "name")!)","\(dict3.value(forKey: "name")!)","\(dict4.value(forKey: "name")!)"]
        }
        
        let month = self.dashboardDataDict["month"] as! NSArray
        let dict = month.object(at: 0) as! NSDictionary
        let dict2 = month.object(at: 1) as! NSDictionary
        let dict3 = month.object(at: 2) as! NSDictionary
        let dict4 = month.object(at: 3) as! NSDictionary
        
        return [dict.value(forKey: "name")!,dict2.value(forKey: "name")!,dict3.value(forKey: "name")!,dict4.value(forKey: "name")!]
        
        
    }
    func chartConfigAxisYValue(_ chart: UUChart!) -> [Any]! {
        if self.dashboardDataDict.count == 0 {
            return [["","","",""]]
        }
        if chart.tag == 9 {
            let year = self.dashboardDataDict["year"] as! NSArray
            
            let dict = year.object(at: 0) as! NSDictionary
            let dict2 = year.object(at: 1) as! NSDictionary
            let dict3 = year.object(at: 2) as! NSDictionary
            let dict4 = year.object(at: 3) as! NSDictionary
            
            return [["\(dict.value(forKey: "value")!)","\(dict2.value(forKey: "value")!)","\(dict3.value(forKey: "value")!)","\(dict4.value(forKey: "value")!)"]]
        }
        
        let month = self.dashboardDataDict["month"] as! NSArray
        let dict = month.object(at: 0) as! NSDictionary
        let dict2 = month.object(at: 1) as! NSDictionary
        let dict3 = month.object(at: 2) as! NSDictionary
        let dict4 = month.object(at: 3) as! NSDictionary
        
        return [["\(dict.value(forKey: "value")!)","\(dict2.value(forKey: "value")!)","\(dict3.value(forKey: "value")!)","\(dict4.value(forKey: "value")!)"]]
    }
    
    func chartConfigColors(_ chart: UUChart!) -> [Any]! {
        //return [UIColor.red ,UIColor.green,UIColor.orange,UIColor.blue]
        let color1 = ObjRef.sharedInstance.magentoGreen
        let color2 = ObjRef.sharedInstance.magentoOrange
        if chart.tag%2 == 0 {
            return [color1 ,color1,color1,color1]
        }
        return [color2 ,color2,color2,color2]
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
