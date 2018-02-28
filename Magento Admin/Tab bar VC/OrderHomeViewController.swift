//
//  OrderHomeViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 14/09/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class OrderHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UUChartDataSource,UIPickerViewDataSource,UIPickerViewDelegate,SimpleBarChartDelegate,SimpleBarChartDataSource {
    
    let kHACPercentage  =    "percentage"
    let kHACColor       =     "color"
    let kHACCustomText  =     "customText"
    
    var inputViewStart = UIView()
    var inputViewEnd = UIView()
    
    var pickerYear = UIPickerView()
    var pickerMonth = UIPickerView()
    var orderData = NSDictionary()
    var orderArr = NSArray()
    var totalOrders = Int()
    var monthCustArr = NSArray()
    var monthRevArr = NSArray()

    
    var monthArr = NSMutableArray()
    var yearArr = NSMutableArray()
    
    var yearRevenueIndex = Int()
    var monthRevenueIndex = Int()
    var yearCustomerIndex = Int()
    var monthCustomerIndex = Int()
    var initialDataLoaded = Bool()
    
    var currentCell = CustomerTableViewCell()
    
    @IBOutlet var custTableView: UITableView!
    var imagesArr = NSArray()
    
    var doneButton2 = UIButton()
    var doneButton = UIButton()

    @IBAction func menuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imagesArr = ["todayOrder.png","lastMonthCust.png","lastYearOrd.png","totalVisit_dash.png"]

        monthArr = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        
        let date = Date()
        
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        monthCustomerIndex = calendar.component(.month, from: date) - 1
        monthRevenueIndex = calendar.component(.month, from: date) - 1
        
        for i in 0  ..< 10  {
            let newYear = year - i
            yearArr.add("\(newYear)")
        }

        
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
        
        //http://magentoapp.newsoftdemo.info/adminapp/order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ
        
        
    }
    func doneStartPickerTapped(sender : UIButton) {
        inputViewStart.isHidden = true
        
        var indexPath = IndexPath(item: 4, section: 0)
        
        if currentCell.barCharView.tag == 4 {
            currentCell.yearFilterLab.text = yearArr.object(at: yearCustomerIndex) as? String
            currentCell.monthFilterLab.text = monthArr.object(at: monthCustomerIndex) as? String
            
        }
        else {
            indexPath = IndexPath(item: 5, section: 0)
            
            currentCell.yearFilterLab.text = yearArr.object(at: yearRevenueIndex) as? String
            currentCell.monthFilterLab.text = monthArr.object(at: monthRevenueIndex) as? String
            
        }
        if let visibleIndexPaths = self.custTableView.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
            if visibleIndexPaths != NSNotFound {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    //self.custTableView.reloadRows(at: [indexPath], with: .fade)
                })
            }
        }
        
        var urlStr = "order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&"
        
        if currentCell.monthFilterLab.text != "" {
            if currentCell.barCharView.tag == 4 {
                urlStr = urlStr + "month=\(monthCustomerIndex + 1)&"
            }
            else {
                urlStr = urlStr + "month=\(monthRevenueIndex + 1)&"
            }
        }
        else {
            return
        }
        
        if currentCell.yearFilterLab.text != "" {
            
            urlStr = urlStr + "year=\(currentCell.yearFilterLab.text!)"
        }
        else {
            return
            
            
            
        }
        
        APIManager.sharedInstance.getRequestWithId(appendParam: urlStr, presentingView: self.view, showLoader: true, onSuccess: { (json) in
            
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
                if json.count > 0 {
                    //self.monthCustArr = json as! NSArray
                    //self.custTableView.reloadData()
                    let indexPath = IndexPath(item: self.currentCell.barCharView.tag, section: 0)
                    if let visibleIndexPaths = self.custTableView.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
                        if visibleIndexPaths != NSNotFound {
                            DispatchQueue.main.async(execute: { () -> Void in
                                if indexPath.row == 4 {
                                    self.monthCustArr = json as! NSArray
                                }
                                else {
                                    self.monthRevArr = json as! NSArray
                                }
                                self.custTableView.reloadRows(at: [indexPath], with: .fade)
                            })
                        }
                    }
                    
                    //                self.orderData = json as! NSArray
                    //                self.userArr = self.orderData.object(at: 0) as! NSMutableArray
                    //                self.userTableView.reloadData()
                }
            }
        }, onFailure: { (error) in
            
            
        })
        
    }
    func doneEndPickerTapped(sender : UIButton) {
        inputViewEnd.isHidden = true
        
        var indexPath = IndexPath(item: 4, section: 0)
        
        if currentCell.barCharView.tag == 4 {
            
            currentCell.yearFilterLab.text = yearArr.object(at: yearCustomerIndex) as? String
            currentCell.monthFilterLab.text = monthArr.object(at: monthCustomerIndex) as? String
            
        }
        else {
            
            indexPath = IndexPath(item: 5, section: 0)
            
            currentCell.yearFilterLab.text = yearArr.object(at: yearRevenueIndex) as? String
            currentCell.monthFilterLab.text = monthArr.object(at: monthRevenueIndex) as? String
            
        }
        if let visibleIndexPaths = self.custTableView.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
            if visibleIndexPaths != NSNotFound {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    // self.custTableView.reloadRows(at: [indexPath], with: .fade)
                })
            }
        }
        
        var urlStr = "order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&"
        
        if currentCell.monthFilterLab.text != "" {
            if currentCell.barCharView.tag == 4 {
                urlStr = urlStr + "month=\(monthCustomerIndex + 1)&"
            }
            else {
                urlStr = urlStr + "month=\(monthRevenueIndex + 1)&"
            }
        }
        else {
            return
        }
        
        if currentCell.yearFilterLab.text != "" {
            urlStr = urlStr + "year=\(currentCell.yearFilterLab.text!)"
        }
        else {
            return
            
//            if currentCell.monthFilterLab.text != "Select" {
//                let endIndex = urlStr.index(urlStr.endIndex, offsetBy: -1)
//                let truncated = urlStr.substring(to: endIndex)
//                
//                urlStr = truncated
//            }
            
        }
        
        APIManager.sharedInstance.getRequestWithId(appendParam: urlStr, presentingView: self.view, showLoader: true, onSuccess: { (json) in
            
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
                if json.count > 0 {
                    
                    //self.monthCustArr = json as! NSArray
                    //self.custTableView.reloadData()
                    let indexPath = IndexPath(item: self.currentCell.barCharView.tag, section: 0)
                    
                    if let visibleIndexPaths = self.custTableView.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
                        if visibleIndexPaths != NSNotFound {
                            DispatchQueue.main.async(execute: { () -> Void in
                                if indexPath.row == 4 {
                                    self.monthCustArr = json as! NSArray
                                }
                                else {
                                    self.monthRevArr = json as! NSArray
                                }
                                self.custTableView.reloadRows(at: [indexPath], with: .fade)
                            })
                        }
                    }
                    
                    //                self.orderData = json as! NSArray
                    //                self.userArr = self.orderData.object(at: 0) as! NSMutableArray
                    //                self.userTableView.reloadData()
                }
            }
        }, onFailure: { (error) in
            
            
        })
        
    }
    @IBAction func yearPickerTapped(_ sender: UIButton) {
        
        if (sender ).tag == 5 {
            
        }
        else {
            
        }
        currentCell = sender.superview?.superview?.superview as! CustomerTableViewCell
        if currentCell.barCharView.tag == 4 {
            self.pickerYear.selectRow(yearCustomerIndex, inComponent: 0, animated: false)
        }
        else {
            self.pickerYear.selectRow(yearRevenueIndex, inComponent: 0, animated: false)
        }
        pickerYear.reloadAllComponents()
        
        self.inputViewStart.isHidden = false
        self.inputViewEnd.isHidden = true
        
    }
    @IBAction func monthPickerTapped(_ sender: UIButton) {
        
        if (sender ).tag == 5 {
            
        }
        else {
            
        }
        currentCell = sender.superview?.superview?.superview as! CustomerTableViewCell
        if currentCell.barCharView.tag == 4 {
            self.pickerMonth.selectRow(monthCustomerIndex, inComponent: 0, animated: false)
        }
        else {
            self.pickerMonth.selectRow(monthRevenueIndex, inComponent: 0, animated: false)
        }
        pickerMonth.reloadAllComponents()
        
        self.inputViewEnd.isHidden = false
        self.inputViewStart.isHidden = true
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = "Order"
        
        if initialDataLoaded == false {
            
            APIManager.sharedInstance.getRequestWithId(appendParam: "order/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ", presentingView: self.view,showLoader : true, onSuccess: { (json) in
                
                if let responseData = json as? NSDictionary {
                    if let active = responseData.object(forKey: "status") as? String {
                        if active == "success" {
                            
                            if let dataObj = responseData.object(forKey: "data") as? NSDictionary {
                                self.orderData = dataObj as! NSDictionary
                                self.initialDataLoaded = true
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.custTableView.reloadData()
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
                
                
            })

        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
       // self.navigationController?.navigationBar.tintColor = UIColor.white
        ObjRef.sharedInstance.setupNavigationBar(vc: self)
        self.custTableView.reloadData()
        
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
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomerTableViewCell
        
        cell.tag = indexPath.row
        
        if indexPath.row > 3 {//

            if indexPath.row < 6 {
                cell = tableView.dequeueReusableCell(withIdentifier: "cellBarChartWithFilter") as! CustomerTableViewCell
                cell.selectionStyle = .none

                cell.yearFilterLab.layer.borderWidth = 1
                cell.monthFilterLab.layer.borderWidth = 1
                if indexPath.row == 5 {
                    cell.filterChartTitle.text = "Revenue Generated In Last 4 Months"
                    cell.yearFilterButton.tag = indexPath.row
                    cell.monthFilterButton.tag = indexPath.row
                }
                else {
                    cell.filterChartTitle.text = "Customer Added In Last 4 Months"
                    cell.yearFilterButton.tag = indexPath.row
                    cell.monthFilterButton.tag = indexPath.row
                    
                }
                
                let fontSize = 16
                
                cell.filterChartTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.filterChartTitle.font.fontName, fontSize: fontSize)
                
                let fontSize2 = 14
                
                cell.yearFilterLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.yearFilterLab.font.fontName, fontSize: fontSize2)
                cell.monthFilterLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.monthFilterLab.font.fontName, fontSize: fontSize2)
                
                if indexPath.row == 4 {
                    cell.yearFilterLab.text = yearArr.object(at: yearCustomerIndex) as? String
                    cell.monthFilterLab.text = monthArr.object(at: monthCustomerIndex) as? String
                }
                else {
                    cell.yearFilterLab.text = yearArr.object(at: yearRevenueIndex) as? String
                    cell.monthFilterLab.text = monthArr.object(at: monthRevenueIndex) as? String
                    
                }
                cell.barCharView = SimpleBarChart(frame: CGRect(x: 18, y: cell.yearFilterLab.frame.origin.y + cell.yearFilterLab.frame.size.height + 30, width: self.view.frame.size.width - 36, height: cell.frame.size.height - cell.barCharView.frame.origin.y - 20))

            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "cellBarChart") as! CustomerTableViewCell
                cell.selectionStyle = .none

                if indexPath.row == 7 {
                    cell.chartTitle.text = "Revenue Generated In Last 4 Years"
                }
                else {
                    cell.chartTitle.text = "Customer Added In Last 4 Years"
                }
                let fontSize = 16
                
                cell.chartTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.chartTitle.font.fontName, fontSize: fontSize)
                
            }
            
            for subview in cell.contentView.subviews {
                
                if subview is SimpleBarChart {
                    subview.removeFromSuperview()
                }
            }
            
            
            cell.barCharView = SimpleBarChart(frame: CGRect(x: 18, y: cell.barCharView.frame.origin.y, width: self.view.frame.size.width - 36, height: cell.frame.size.height - cell.barCharView.frame.origin.y - 20))
            
            //cell.barCharView.frame = CGRect(x: 18, y: cell.barCharView.frame.origin.y, width: self.view.frame.size.width - 36, height: cell.frame.size.height - cell.barCharView.frame.origin.y - 30)
            //cell.barCharView.center					= CGPoint(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
            cell.barCharView.delegate					= self;
            cell.barCharView.dataSource				= self;
            cell.barCharView.barShadowOffset		= CGSize(width: 2.0, height: 1.0)
            cell.barCharView.animationDuration		= 1.0;
            cell.barCharView.barShadowColor			= UIColor.gray
            cell.barCharView.barShadowAlpha			= 0.5;
            cell.barCharView.barShadowRadius			= 1.0;
            cell.barCharView.barWidth					= self.view.frame.size.width*0.135;
            cell.barCharView.xLabelType				= SimpleBarChartXLabelTypeHorizontal;
            cell.barCharView.incrementValue			= 10;
            cell.barCharView.barTextType			= SimpleBarChartBarTextTypeTop;
            cell.barCharView.barTextColor			= UIColor.white
            cell.barCharView.gridColor				= UIColor.clear
            
            //cell.barCharView = UUChart(frame: CGRect(x: 5, y: cell.barCharView.frame.origin.y, width: self.view.frame.size.width - 10, height: cell.frame.size.height - cell.barCharView.frame.origin.y*1.25), dataSource: self, style: UUChartStyle.bar)
            cell.barCharView.tag = indexPath.row
            
            cell.contentView.addSubview(cell.barCharView)
            cell.barCharView.reloadData()
        }
        else {
            let imageName = self.imagesArr.object(at: indexPath.row) as! String
            cell.cellImage.image = UIImage(named: imageName)
            
            let fontSize = 14
            let valueFontSize = 16
            
            
            cell.cellTitle.font = ObjRef.sharedInstance.updateFont(fontName: cell.cellTitle.font.fontName, fontSize: fontSize)
            cell.cellTitleVal.font = ObjRef.sharedInstance.updateFont(fontName: cell.cellTitleVal.font.fontName, fontSize: valueFontSize)
            cell.cellTitleRevenueVal.font = ObjRef.sharedInstance.updateFont(fontName: cell.cellTitleRevenueVal.font.fontName, fontSize: valueFontSize)
            cell.cellRevLab.font = ObjRef.sharedInstance.updateFont(fontName: cell.cellRevLab.font.fontName, fontSize: fontSize)
            cell.viewAllButton.titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: (cell.viewAllButton.titleLabel?.font.fontName)!, fontSize: fontSize - 2)
            
            
            if indexPath.row != 3 {
                cell.viewAllButton.isHidden = true
                cell.selectionStyle = .none

            }
            else {
                cell.viewAllButton.isHidden = false
                cell.selectionStyle = .default

            }
            
            if indexPath.row == 0 {
                cell.cellTitle.text = "Today's Orders"
                if self.orderData.count > 0 {
                    cell.cellTitleRevenueVal.text = self.orderData["today_revenue"] as? String
                    cell.cellTitleVal.text = "\(self.orderData["today"]!)"
                    
                }

                
            }
            else if indexPath.row == 1 {
                cell.cellTitle.text = "Last Month Orders"
                if self.orderData.count > 0 {
                    
                    cell.cellTitleRevenueVal.text = "\(self.orderData["last_month_revenue"]!)"
                    cell.cellTitleVal.text = "\(self.orderData["last_month"]!)"
                    
                }

            }
            else if indexPath.row == 2 {
                cell.cellTitle.text = "Last Year Orders"
                if self.orderData.count > 0 {
                    
                    cell.cellTitleRevenueVal.text = "\(self.orderData["last_year_revenue"]!)"
                    cell.cellTitleVal.text = "\(self.orderData["last_year"]!)"
                    
                }

            }
            else if indexPath.row == 3{
                cell.cellTitle.text = "Total Orders"
                if self.orderData.count > 0 {
                    
                    cell.cellTitleRevenueVal.text = "\(self.orderData["total_revenue"]!)"
                    cell.cellTitleVal.text = "\(self.orderData["total"]!)"
                    totalOrders = (self.orderData["total"]! as! Int)
                    
                }

            }
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 3 {//
            if indexPath.row < 6 {
                return 300
            }
            return 250
        }
        return 85
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if indexPath.row == 3 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController4Internal") as! OrderViewController
                vc.totalOrders = totalOrders

                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 20))
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    //MARK: bar chart delegaet
    
    func numberOfBars(in barChart: SimpleBarChart!) -> UInt {
        return 4
    }
    
    func barChart(_ barChart: SimpleBarChart!, valueForBarAt index: UInt) -> CGFloat {
        
        if self.orderData.count == 0 {
            return 0
        }
        
        if barChart.tag == 6 || barChart.tag == 7 {
            let year = self.orderData["order_year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            if barChart.tag == 6 {
                return dict.value(forKey: "total")! as! CGFloat
            }
            
            return self.removeDollarFromString(str: "\(dict.value(forKey: "revenue")!)")
        }
        
        var month = self.orderData["order_month"] as! NSArray
        if self.monthCustArr.count > 0 && barChart.tag == 4 {
            month = self.monthCustArr
        }
        if self.monthRevArr.count > 0 && barChart.tag == 5 {
            month = self.monthRevArr
        }

        let dict = month.object(at: Int(index)) as! NSDictionary
        
        
        if barChart.tag == 4 {
            return dict.value(forKey: "total")! as! CGFloat
        }
        return self.removeDollarFromString(str: "\(dict.value(forKey: "revenue")!)")
        
    }
    
    func barChart(_ barChart: SimpleBarChart!, textForBarAt index: UInt) -> String! {
        if self.orderData.count == 0 {
            return ""
        }
        
        if barChart.tag == 6 || barChart.tag == 7 {
            let year = self.orderData["order_year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            
            if barChart.tag == 6 {
                return "\(dict.value(forKey: "total")!)"
            }
            return "\(self.removeDollarFromString(str: "\(dict.value(forKey: "revenue")!)"))"
            
        }
        
        var month = self.orderData["order_month"] as! NSArray
        if self.monthCustArr.count > 0 && barChart.tag == 4 {
            month = self.monthCustArr
        }
        if self.monthRevArr.count > 0 && barChart.tag == 5 {
            month = self.monthRevArr
        }

        let dict = month.object(at: Int(index)) as! NSDictionary
        
        
        if barChart.tag == 4 {
            return "\(dict.value(forKey: "total")!)"
        }
        return "\(self.removeDollarFromString(str: "\(dict.value(forKey: "revenue")!)"))"
        
    }
    func barChart(_ barChart: SimpleBarChart!, xLabelForBarAt index: UInt) -> String! {
        if self.orderData.count == 0 {
            return ""
        }
        
        if barChart.tag == 6 || barChart.tag == 7 {
            let year = self.orderData["order_year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            
            
            return "\(dict.value(forKey: "name")!)"
        }
        
        var month = self.orderData["order_month"] as! NSArray
        if self.monthCustArr.count > 0 && barChart.tag == 4 {
            month = self.monthCustArr
        }
        if self.monthRevArr.count > 0 && barChart.tag == 5 {
            month = self.monthRevArr
        }

        let dict = month.object(at: Int(index)) as! NSDictionary
        
        
        return ("\(dict.value(forKey: "name")!)" as NSString).substring(to: 3)
    }
    func barChart(_ barChart: SimpleBarChart!, colorForBarAt index: UInt) -> UIColor! {
        
        let color1 = ObjRef.sharedInstance.magentoGreen
        let color2 = ObjRef.sharedInstance.magentoOrange
        if barChart.tag%2 == 0 {
            return color1
        }
        return color2
        
    }

    func chartConfigAxisXLabel(_ chart: UUChart!) -> [Any]! {
        
        
        if self.orderData.count == 0 {
            return ["","","",""]
        }
        
        //return ["","","",""]
        
        if chart.tag == 6 || chart.tag == 7 {
            let year = self.orderData["order_year"] as! NSArray
            let dict = year.object(at: 0) as! NSDictionary
            let dict2 = year.object(at: 1) as! NSDictionary
            let dict3 = year.object(at: 2) as! NSDictionary
            let dict4 = year.object(at: 3) as! NSDictionary
            
            return ["\(dict.value(forKey: "name")!)","\(dict2.value(forKey: "name")!)","\(dict3.value(forKey: "name")!)","\(dict4.value(forKey: "name")!)"]
        }
        
        var month = self.orderData["order_month"] as! NSArray
        if self.monthCustArr.count > 0 && chart.tag == 4 {
            month = self.monthCustArr
        }
        let dict = month.object(at: 0) as! NSDictionary
        let dict2 = month.object(at: 1) as! NSDictionary
        let dict3 = month.object(at: 2) as! NSDictionary
        let dict4 = month.object(at: 3) as! NSDictionary
        
        return [dict.value(forKey: "name")!,dict2.value(forKey: "name")!,dict3.value(forKey: "name")!,dict4.value(forKey: "name")!]
        
        
    }
    func chartConfigAxisYValue(_ chart: UUChart!) -> [Any]! {
        if self.orderData.count == 0 {
            return [["","","",""]]
        }
        
        let year = self.orderData["order_year"] as! NSArray
        var month = self.orderData["order_month"] as! NSArray
        if self.monthCustArr.count > 0 && chart.tag == 4 {
            month = self.monthCustArr
        }
        //return [["","","",""]]
        if chart.tag == 7 || chart.tag == 6 {
            
            let dict = year.object(at: 0) as! NSDictionary
            let dict2 = year.object(at: 1) as! NSDictionary
            let dict3 = year.object(at: 2) as! NSDictionary
            let dict4 = year.object(at: 3) as! NSDictionary
            if chart.tag == 6 {
                return [["\(dict.value(forKey: "total")!)" ,"\(dict2.value(forKey: "total")!)","\(dict3.value(forKey: "total")!)","\(dict4.value(forKey: "total")!)"]]
            }
            return [[self.removeDollarFromString(str: "\(dict.value(forKey: "revenue")!)") ,self.removeDollarFromString(str: "\(dict2.value(forKey: "revenue")!)"),self.removeDollarFromString(str: "\(dict3.value(forKey: "revenue")!)"),self.removeDollarFromString(str: "\(dict4.value(forKey: "revenue")!)")]]
        }
        else {
            let dict = month.object(at: 0) as! NSDictionary
            let dict2 = month.object(at: 1) as! NSDictionary
            let dict3 = month.object(at: 2) as! NSDictionary
            let dict4 = month.object(at: 3) as! NSDictionary
            
            if chart.tag == 4 {
                return [["\(dict.value(forKey: "total")!)" ,"\(dict2.value(forKey: "total")!)","\(dict3.value(forKey: "total")!)","\(dict4.value(forKey: "total")!)"]]
            }
            
            return [[self.removeDollarFromString(str: "\(dict.value(forKey: "revenue")!)") ,self.removeDollarFromString(str: "\(dict2.value(forKey: "revenue")!)"),self.removeDollarFromString(str: "\(dict3.value(forKey: "revenue")!)"),self.removeDollarFromString(str: "\(dict4.value(forKey: "revenue")!)")]]
        }
    }
    func chartConfigColors(_ chart: UUChart!) -> [Any]! {
        let color1 = ObjRef.sharedInstance.magentoGreen
        let color2 = ObjRef.sharedInstance.magentoOrange
        if chart.tag%2 == 0 {
            return [color1 ,color1,color1,color1]
        }
        return [color2 ,color2,color2,color2]

    }
    func removeDollarFromString(str : String) -> CGFloat {
        
        return CGFloat((str.replacingOccurrences(of: "$", with: "") as NSString).floatValue)
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
            if currentCell.barCharView.tag == 4 {
                yearCustomerIndex = row
            }
            else {
                yearRevenueIndex = row
            }
        }
        if pickerView == pickerMonth {
            if currentCell.barCharView.tag == 4 {
                monthCustomerIndex = row
            }
            else {
                monthRevenueIndex = row
            }
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
