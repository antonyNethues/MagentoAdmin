//
//  CustomerViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit
import SwiftCharts

class CustomerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UUChartDataSource,UIPickerViewDataSource,UIPickerViewDelegate,SimpleBarChartDelegate,SimpleBarChartDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let kHACPercentage  =    "percentage"
    let kHACColor       =     "color"
    let kHACCustomText  =     "customText"
    
    @IBOutlet var buttonAllTime: UIButton!
    @IBOutlet var buttonMonth: UIButton!
    @IBOutlet var buttonWeek: UIButton!
    @IBOutlet var buttonToday: UIButton!
    @IBOutlet var topFilterView: UIView!
    var inputViewStart = UIView()
    var inputViewEnd = UIView()
    var totalCustomer = Int()
    var lastYearCustomer = Int()
    var lastMonthCustomer = Int()
    var initialDataLoaded = Bool()

    var pickerYear = UIPickerView()
    var pickerMonth = UIPickerView()
    var customerData = NSDictionary()
    
    var monthArr = NSMutableArray()
    var yearArr = NSMutableArray()
    var monthCustArr = NSArray()
    var monthRevArr = NSArray()
    
    var yearRevenueIndex = Int()
    var monthRevenueIndex = Int()
    var yearCustomerIndex = Int()
    var monthCustomerIndex = Int()
    var currentIndexFilter = Int()
    var customersChartData = NSArray()

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
        
        imagesArr = ["todayCustomer_dash.png","lastMonthCust.png","lastYearOrd.png","totalCust.png"]

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

        let searchImage = UIImage(named: "refresh")!
        let clipImage = UIImage(named: "add")!
        let pencilImage = UIImage(named: "menu")!
        
        let searchBtn: UIButton = UIButton()
        searchBtn.setImage(searchImage, for: UIControlState.normal)
        searchBtn.addTarget(self, action: #selector(self.reloadTapped), for: UIControlEvents.touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let searchBarBtn = UIBarButtonItem(customView: searchBtn)
        
        let clipBtn: UIButton = UIButton()
        clipBtn.setImage(clipImage, for: UIControlState.normal)
        clipBtn.addTarget(self, action: #selector(self.addTapped), for: UIControlEvents.touchUpInside)
        clipBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)
        
        let pencilBtn: UIButton = UIButton()
        pencilBtn.setImage(pencilImage, for: UIControlState.normal)
        pencilBtn.addTarget(self, action: #selector(self.menuTapped(_:)), for: UIControlEvents.touchUpInside)
        pencilBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let pencilBarBtn = UIBarButtonItem(customView: pencilBtn)
        
        self.navigationItem.setRightBarButtonItems([searchBarBtn,clipBarBtn], animated: false)

        self.navigationItem.setLeftBarButtonItems([pencilBarBtn], animated: false)
        
        topFilterView.layer.borderColor = ObjRef.sharedInstance.magentoOrange.cgColor
        topFilterView.layer.borderWidth = 0.5
    }
    
    func addTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditCustomer") as! EditCustomerViewController
                
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func doneStartPickerTapped(sender : UIButton) {
        inputViewStart.isHidden = true
        
        var indexPath = IndexPath(item: 4, section: 0)

//        if currentCell.barCharView.tag == 4 {
            currentCell.buttonSelectYear.titleLabel?.text = yearArr.object(at: yearCustomerIndex) as? String
            currentCell.buttonSelectMonth.titleLabel?.text = monthArr.object(at: monthCustomerIndex) as? String
            
//        }
//        else {
//            indexPath = IndexPath(item: 5, section: 0)
//
//            currentCell.buttonSelectYear.titleLabel?.text = yearArr.object(at: yearRevenueIndex) as? String
//            currentCell.buttonSelectMonth.titleLabel?.text = monthArr.object(at: monthRevenueIndex) as? String
//
//        }
        
        if let visibleIndexPaths = self.custTableView.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
            if visibleIndexPaths != NSNotFound {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    //self.custTableView.reloadRows(at: [indexPath], with: .fade)
                })
            }
        }
        return
        var urlStr = "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&"
        
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
                    
                    //                self.customerData = json as! NSArray
                    //                self.userArr = self.customerData.object(at: 0) as! NSMutableArray
                    //                self.userTableView.reloadData()
                }
            }
            
        }, onFailure: { (error) in
            
            
        })
        
    }
    func doneEndPickerTapped(sender : UIButton) {
        inputViewEnd.isHidden = true
        
        var indexPath = IndexPath(item: 4, section: 0)
        
//        if currentCell.barCharView.tag == 4 {
        
            currentCell.buttonSelectYear.titleLabel?.text = yearArr.object(at: yearCustomerIndex) as? String
            currentCell.buttonSelectMonth.titleLabel?.text = monthArr.object(at: monthCustomerIndex) as? String
            
//        }
//        else {
//
//            indexPath = IndexPath(item: 5, section: 0)
//
//            currentCell.buttonSelectYear.titleLabel?.text = yearArr.object(at: yearRevenueIndex) as? String
//            currentCell.buttonSelectMonth.titleLabel?.text = monthArr.object(at: monthRevenueIndex) as? String
//
//        }
        if let visibleIndexPaths = self.custTableView.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
            if visibleIndexPaths != NSNotFound {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                   // self.custTableView.reloadRows(at: [indexPath], with: .fade)
                })
            }
        }
        return
        
        var urlStr = "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ&"
        
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
                    
                   // self.monthCustArr = json as! NSArray
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
                    
                    //                self.customerData = json as! NSArray
                    //                self.userArr = self.customerData.object(at: 0) as! NSMutableArray
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
//        if currentCell.barCharView.tag == 4 {
//            self.pickerYear.selectRow(yearCustomerIndex, inComponent: 0, animated: false)
//        }
//        else {
        
        self.pickerYear.selectRow(yearRevenueIndex, inComponent: 0, animated: false)
//        }
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
        
//        if currentCell.barCharView.tag == 4 {
//            self.pickerMonth.selectRow(monthCustomerIndex, inComponent: 0, animated: false)
//        }
//        else {
            self.pickerMonth.selectRow(monthRevenueIndex, inComponent: 0, animated: false)
//        }
        
        pickerMonth.reloadAllComponents()

        self.inputViewEnd.isHidden = false
        self.inputViewStart.isHidden = true

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // if initialDataLoaded == false {
            self.reloadTapped()
      //  }
        self.title = "Customer"
    }
    func reloadTapped() {
        
        APIManager.sharedInstance.getRequestWithId(appendParam: "customer/getdata/?token=ABCDEFGHIJKLMNOPQRSTUVWXYZ", presentingView: self.view,showLoader : true, onSuccess: { (json) in
            
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
                    
                    if json.count > 0 {
                        self.customerData = json as! NSDictionary
                        self.initialDataLoaded = true
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.custTableView.reloadData()
                        })
                    }
                }
            }
            
        }, onFailure: { (error) in
            
            
        })

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
       // self.navigationController?.navigationBar.tintColor = UIColor.white
        ObjRef.sharedInstance.setupNavigationBar(vc: self)
        self.custTableView.reloadData()
        
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellBarChartNew") as! CustomerTableViewCell

        if indexPath.row == 0 {//
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellBarChartNew") as! CustomerTableViewCell
            
            // cell = tableView.dequeueReusableCell(withIdentifier: "cellBarChartNew") as! CustomerTableViewCell
            
            cell.tag = indexPath.row
            
            cell.selectionStyle = .none
            
            
            if indexPath.row == 11 {
                // cell.barChartTitle.text = "LAST 4 YEARS VISITORS"
            }
            // cell.reloadButton.tag = indexPath.row
            
            cell.collectionViewCustomer.reloadData()
            
            
            //        cell.collectionViewCustomer.scrollToItem(at: IndexPath(item: 2, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            
            
            
            self.updateCellFont(superV: cell.contentView)
            
            return cell
        }
        else if indexPath.row < 4 {//
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "cellAverageData") as! CustomerTableViewCell
                
                // cell = tableView.dequeueReusableCell(withIdentifier: "cellBarChartNew") as! CustomerTableViewCell
                
                cell.tag = indexPath.row
                
                cell.selectionStyle = .none
            
                
                self.updateCellFont(superV: cell.contentView)
                
                return cell
        }
        else if indexPath.row == 4 {//
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellViewAll") as! CustomerTableViewCell
            
            // cell = tableView.dequeueReusableCell(withIdentifier: "cellBarChartNew") as! CustomerTableViewCell
            
            cell.tag = indexPath.row
            
            cell.selectionStyle = .none
            
            
            self.updateCellFont(superV: cell.contentView)
            
            return cell
        }
            
        //cellAverageData
        else if indexPath.row > 3 {//
            

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
            
            
            if indexPath.row == 0 {
                cell.viewAllButton.isHidden = true
                cell.selectionStyle = .none
                
            }
            else {
                cell.viewAllButton.isHidden = false
                cell.selectionStyle = .default
                
            }
            
            if indexPath.row == 0 {
                cell.cellTitle.text = "Today's Customer"
                if self.customerData.count > 0 {
                    cell.cellTitleRevenueVal.text = self.customerData["today_revenue"] as? String
                    
                    cell.cellTitleVal.text = "\(self.customerData["today"]!)"
                    
                }
                
            }
            else if indexPath.row == 1 {
                cell.cellTitle.text = "Last Month Customers"
                if self.customerData.count > 0 {
                    
                    cell.cellTitleRevenueVal.text = "\(self.customerData["last_month_revenue"]!)"
                    
                    cell.cellTitleVal.text = "\(self.customerData["last_month"]!)"
                    lastMonthCustomer = (self.customerData["last_month"]! as! Int)
                    
                }
            }
            else if indexPath.row == 2 {
                cell.cellTitle.text = "Last Year Customers"
                if self.customerData.count > 0 {
                    
                    cell.cellTitleRevenueVal.text = "\(self.customerData["last_year_revenue"]!)"
                    
                    cell.cellTitleVal.text = "\(self.customerData["last_year"]!)"
                    lastYearCustomer = (self.customerData["last_year"]! as! Int)
                    
                }
            }
            else if indexPath.row == 3{
                cell.cellTitle.text = "Total Customers"
                if self.customerData.count > 0 {
                    
                    cell.cellTitleRevenueVal.text = "\(self.customerData["total_revenue"]!)"
                    
                    cell.cellTitleVal.text = "\(self.customerData["total"]!)"
                    totalCustomer = (self.customerData["total"]! as! Int)
                    
                }
            }
            
        }
        
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0 {//
            if indexPath.row == 4 {
                return 40
            }
            return 70
        }
        return 275
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row > 0 {
            if indexPath.row == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreMessageSegue") as! CustomerIntViewController
                vc.lastMonthBool = true
                vc.lastMonthCustomer = lastMonthCustomer
                vc.totalCustomer = totalCustomer

                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreMessageSegue") as! CustomerIntViewController
                vc.lastYearBool = true
                vc.lastYearCustomer = lastYearCustomer
                vc.totalCustomer = totalCustomer
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 3 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreMessageSegue") as! CustomerIntViewController
            
                vc.totalCustomer = totalCustomer
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
    func updateCellFont(superV:UIView){
        for subV in superV.subviews {
            if subV is UILabel {
                (subV as! UILabel).font = ObjRef.sharedInstance.updateFont(fontName: (subV as! UILabel).font.fontName, fontSize: 13)
            }
            else if subV is UIButton {
                (subV as! UIButton).titleLabel?.font = ObjRef.sharedInstance.updateFont(fontName: ((subV as! UIButton).titleLabel?.font.fontName)!, fontSize: 13)
            }
            else if subV is UIView {
                self.updateCellFont(superV: subV)
            }
        }
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
        
        if (customersChartData.count > 0 && cellTag == 0) {
            
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
//                dict1 = self.ordersChartData.object(at: 0) as! NSDictionary
//                dict2 = self.ordersChartData.object(at: 1) as! NSDictionary
//                dict3 = self.ordersChartData.object(at: 2) as! NSDictionary
//                dict4 = self.ordersChartData.object(at: 3) as! NSDictionary
//                dict5 = self.ordersChartData.object(at: 4) as! NSDictionary
//                dict6 = self.ordersChartData.object(at: 5) as! NSDictionary
//                dict7 = self.ordersChartData.object(at: 6) as! NSDictionary
                
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
                ChartStackedBarItemModel(quantity: 20, bgColor: color0),
                ChartStackedBarItemModel(quantity: 30, bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name2, order: 2, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 30, bgColor: color0),
                ChartStackedBarItemModel(quantity: 20, bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name3, order: 3, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 40, bgColor: color0),
                ChartStackedBarItemModel(quantity: 50, bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name4, order: 4, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 10, bgColor: color0),
                ChartStackedBarItemModel(quantity: 40, bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name5, order: 5, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 30, bgColor: color0),
                ChartStackedBarItemModel(quantity: 40, bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name6, order: 6, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 10, bgColor: color0),
                ChartStackedBarItemModel(quantity: 20, bgColor: color1)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString(name7, order: 7, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 40, bgColor: color0),
                ChartStackedBarItemModel(quantity: 10, bgColor: color1)
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
        let chartFrame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width*0.9), height: ((superV.frame.size.height)))
        
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
    //MARK: top view buttons
    
    @IBAction func todayButtonTapped(_ sender: Any) {
        
        
       // self.changeButtonTextColorAndBack(button: self.buttonToday)
        if let cell = custTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomerTableViewCell  {
            if let collectionV = cell.collectionViewCustomer as? UICollectionView    {
                //collectionV.delegate = nil
                collectionV.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
               // collectionV.delegate = self

            }
        }
    }
    
    @IBAction func weekButtonTapped(_ sender: Any) {
        

        //self.changeButtonTextColorAndBack(button: self.buttonWeek)
        if let cell = custTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomerTableViewCell  {
            if let collectionV = cell.collectionViewCustomer as? UICollectionView    {
                collectionV.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
            }
        }
    }
    
    @IBAction func monthButtonTapped(_ sender: Any) {
        

       // self.changeButtonTextColorAndBack(button: self.buttonMonth)
        if let cell = custTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomerTableViewCell  {
            if let collectionV = cell.collectionViewCustomer as? UICollectionView    {
                collectionV.scrollToItem(at: IndexPath(item: 2, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
            }
        }
    }
    
    
    @IBAction func allTimeButtonTapped(_ sender: Any) {
        

        //self.changeButtonTextColorAndBack(button: self.buttonAllTime)
        if let cell = custTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomerTableViewCell  {
            if let collectionV = cell.collectionViewCustomer as? UICollectionView    {
                collectionV.scrollToItem(at: IndexPath(item: 3, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
            }
        }
    }
    
    //MARK: collection view delegaet

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomerCollectionCell
        
        for subview in cell.contentView.subviews {
            
            if subview is ChartView {
                subview.removeFromSuperview()
            }
        }
        let chart = self.chart(horizontal: false, superV: collectionView, cellTag: indexPath.row)
        
        chart.view.isUserInteractionEnabled = false
        
        cell.contentView.addSubview(chart.view)
        cell.chart = chart
       // cell.chart?.view.backgroundColor = UIColor.red
        
        cell.colorRev.layer.cornerRadius = cell.colorRev.frame.size.width*0.5
        cell.colorCustomer.layer.cornerRadius = cell.colorCustomer.frame.size.width*0.5

        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if scrollView.frame.size.width == self.view.frame.size.width {
            return
        }
        
        let currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        if currentIndex == 0 {
            self.changeButtonTextColorAndBack(button: self.buttonToday)
        }
        else if currentIndex == 1 {
            self.changeButtonTextColorAndBack(button: self.buttonWeek)
        }
        else if currentIndex == 2 {
            self.changeButtonTextColorAndBack(button: self.buttonMonth)
        }
        else if currentIndex == 3 {
            self.changeButtonTextColorAndBack(button: self.buttonAllTime)
        }
        
    }
    func changeButtonTextColorAndBack(button : UIButton) {
        buttonToday.backgroundColor = UIColor.white
        buttonToday.titleLabel?.textColor = ObjRef.sharedInstance.magentoOrange
       
        buttonWeek.backgroundColor = UIColor.white
        buttonWeek.titleLabel?.textColor = ObjRef.sharedInstance.magentoOrange
       
        buttonMonth.backgroundColor = UIColor.white
        buttonMonth.titleLabel?.textColor = ObjRef.sharedInstance.magentoOrange
        
        buttonAllTime.backgroundColor = UIColor.white
        buttonAllTime.titleLabel?.textColor = ObjRef.sharedInstance.magentoOrange
        
        button.titleLabel?.textColor = UIColor.white
        button.backgroundColor = ObjRef.sharedInstance.magentoOrange
        
    }
    //MARK: bar chart delegaet
    
    func numberOfBars(in barChart: SimpleBarChart!) -> UInt {
        return 4
    }
    
    func barChart(_ barChart: SimpleBarChart!, valueForBarAt index: UInt) -> CGFloat {
        
        if self.customerData.count == 0 {
            return 0
        }
        
        if barChart.tag == 6 || barChart.tag == 7 {
            let year = self.customerData["customer_year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            if barChart.tag == 6 {
                return dict.value(forKey: "total")! as! CGFloat
            }
            
            return self.removeDollarFromString(str: "\(dict.value(forKey: "revenue")!)")
        }
        

        var month = self.customerData["customer_month"] as! NSArray
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
        if self.customerData.count == 0 {
            return ""
        }
        
        if barChart.tag == 6 || barChart.tag == 7 {
            let year = self.customerData["customer_year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            
            if barChart.tag == 6 {
                return "\(dict.value(forKey: "total")!)"
            }
            return "\(self.removeDollarFromString(str: "\(dict.value(forKey: "revenue")!)"))"

        }
        
        var month = self.customerData["customer_month"] as! NSArray
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
        if self.customerData.count == 0 {
            return ""
        }
        
        if barChart.tag == 6 || barChart.tag == 7 {
            let year = self.customerData["customer_year"] as! NSArray
            let dict = year.object(at: Int(index)) as! NSDictionary
            
            
            return "\(dict.value(forKey: "name")!)"
        }
        
        var month = self.customerData["customer_month"] as! NSArray
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
        
        
        if self.customerData.count == 0 {
            return ["","","",""]
        }
        
        //return ["","","",""]

        if chart.tag == 6 || chart.tag == 7 {
            let year = self.customerData["customer_year"] as! NSArray
            let dict = year.object(at: 0) as! NSDictionary
            let dict2 = year.object(at: 1) as! NSDictionary
            let dict3 = year.object(at: 2) as! NSDictionary
            let dict4 = year.object(at: 3) as! NSDictionary
            
            return ["\(dict.value(forKey: "name")!)","\(dict2.value(forKey: "name")!)","\(dict3.value(forKey: "name")!)","\(dict4.value(forKey: "name")!)"]
            
            
        }
        
        var month = self.customerData["customer_month"] as! NSArray
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
        if self.customerData.count == 0 {
            return [["","","",""]]
        }
        
        let year = self.customerData["customer_year"] as! NSArray
        var month = self.customerData["customer_month"] as! NSArray
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
//            if currentCell.barCharView.tag == 4 {
                yearCustomerIndex = row
//            }
//            else {
//                yearRevenueIndex = row
////            }
        }
        if pickerView == pickerMonth {
//            if currentCell.barCharView.tag == 4 {
                monthCustomerIndex = row
////            }
////            else {
//                monthRevenueIndex = row
////            }
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
