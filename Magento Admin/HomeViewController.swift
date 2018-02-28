//
//  HomeViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 30/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class HomeViewController: SlideMenuController,UITabBarDelegate,SlideMenuControllerDelegate {

    @IBOutlet var filterScrollView: UIScrollView!
    var date: NSDate?
    var dateTo: NSDate?
    var timePicker: UIDatePicker?
    var toTimePicker: UIDatePicker?
    var activeTextField : UITextField!

    @IBOutlet var filterBgView: UIView!
    
    @IBOutlet var dateMaxTextF: UITextField!
    @IBOutlet var dateMinTextF: UITextField!
    @IBOutlet var emailTextF: UITextField!
    @IBOutlet var idTextF: UITextField!
    //@IBOutlet var statusTextF: UITextField!
    @IBOutlet var custNameTextF: UITextField!
    @IBOutlet var filterView: UIView!
    @IBOutlet var upperViewContainer: UIView!
    @IBOutlet var customTabBar: CustomTabBar!
    var boolVal = Int()

    var shadowViewCont : UIViewController!
    var bgView = UIView()
    var bgView2 = UIView()
    var bgView3 = UIView()
    var bgView4 = UIView()
    var bgView5 = UIView()
    
    @IBOutlet var orderItem: UITabBarItem!
    @IBOutlet var customerItem: UITabBarItem!
    @IBOutlet var productItem: UITabBarItem!
    @IBOutlet var CategoryItem: UITabBarItem!
    @IBOutlet var dashboardItem: UITabBarItem!
    
    var viewController1: UITabBarController?
    var viewController2_1: UITabBarController?
    var viewController2: UITabBarController?
    var viewController3: UITabBarController?
    var viewController4: UITabBarController?
    
    var imagesArr = NSArray()
    
    var layoutUpdated = Bool()
    var layerGradient = CAGradientLayer()
    
    var currentSenderVC = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUpdated = true
        
        self.delegate = self
        if self.customTabBar != nil {
            self.customTabBar.delegate = self
        }
        // Do any additional setup after loading the view.
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Right") {
            self.leftViewController = controller
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tabBar(self.customTabBar, didSelect: self.dashboardItem)
            self.customTabBar.selectedItem = self.dashboardItem
        })
        
        //self.customTabBar.backgroundColor = ObjRef.sharedInstance.magentoOrange
        //self.customTabBar.isTranslucent = true
        self.customTabBar.isOpaque = false
        //self.customTabBar.tintColor = UIColor.lightGray
        
        let normalTitleFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        
       UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:normalTitleFont], for: .normal)

        layerGradient = CAGradientLayer()
        layerGradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor,UIColor.clear.cgColor,UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor]
        
        layerGradient.startPoint = CGPoint(x: 0, y: 0.1)
        layerGradient.endPoint = CGPoint(x: 0, y:0.9 )
        layerGradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.customTabBar.frame.size.height)
        //self.customTabBar.layer.insertSublayer(layerGradient, at: 0)
        
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        var tabBarWidth = width
        if height > width {
            tabBarWidth = height
        }
        
        let itemWidth = tabBarWidth / CGFloat(self.customTabBar.items!.count)
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: customTabBar.frame.height))
        bgView.backgroundColor = UIColor(red: 249/255.0, green: 91/255.0, blue: 33/255.0, alpha: 1.0)
        self.customTabBar.insertSubview(bgView, at: 1)

        bgView2 = UIView(frame: CGRect(x: itemWidth*1, y: 0, width: itemWidth, height: customTabBar.frame.height))
        bgView2.backgroundColor = UIColor(red: 249/255.0, green: 91/255.0, blue: 33/255.0, alpha: 1.0)
        self.customTabBar.insertSubview(bgView2, at: 1)

        bgView3 = UIView(frame: CGRect(x: itemWidth*2, y: 0, width: itemWidth, height: customTabBar.frame.height))
        bgView3.backgroundColor = UIColor(red: 249/255.0, green: 91/255.0, blue: 33/255.0, alpha: 1.0)
        self.customTabBar.insertSubview(bgView3, at: 1)

        bgView4 = UIView(frame: CGRect(x: itemWidth*3, y: 0, width: itemWidth, height: customTabBar.frame.height))
        bgView4.backgroundColor = UIColor(red: 249/255.0, green: 91/255.0, blue: 33/255.0, alpha: 1.0)
        self.customTabBar.insertSubview(bgView4, at: 1)

        bgView5 = UIView(frame: CGRect(x: itemWidth*4, y: 0, width: itemWidth, height: customTabBar.frame.height))
        bgView5.backgroundColor = UIColor(red: 249/255.0, green: 91/255.0, blue: 33/255.0, alpha: 1.0)
        self.customTabBar.insertSubview(bgView5, at: 1)

        
        //UIFont.boldSystemFont(ofSize: (self.view.frame.size.width/320)*9
        //title color of tabbar
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: ObjRef.sharedInstance.magentoOrange,NSFontAttributeName: ObjRef.sharedInstance.updateFont(fontName: "", fontSize: 9)], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: ObjRef.sharedInstance.updateFont(fontName: "", fontSize: 9)], for:.selected)
        
        self.initDatePicker()

       // self.showExampleController(StackedBarsExample())
    }
    fileprivate func showExampleController(_ controller: UIViewController) {
//        if let currentExampleController = currentExampleController {
//            currentExampleController.removeFromParentViewController()
//            currentExampleController.view.removeFromSuperview()
//        }
        addChildViewController(controller)
        view.addSubview(controller.view)
        //currentExampleController = controller
    }
    func changeColorOfButton(view : UIView) {
        
        bgView.backgroundColor = UIColor.white
        bgView2.backgroundColor = UIColor.white
        bgView3.backgroundColor = UIColor.white
        bgView4.backgroundColor = UIColor.white
        bgView5.backgroundColor = UIColor.white

        view.backgroundColor = ObjRef.sharedInstance.magentoOrange
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.customTabBar.isTranslucent = false
        //self.navigationController?.navigationBar.isHidden = true
        //UITabBar.appearance().tintColor = UIColor.white
        imagesArr = ["dashboard.png","products-list.png","category.png","customer.png","search2.png"]
        self.customTabBar.tintColor = UIColor.white
        self.customTabBar.barTintColor = ObjRef.sharedInstance.magentoOrange

        if let items = self.customTabBar.items {
            var tabBarImages = UIImage(named: "search") // tabBarImages: [UIImage]
            
            for i in 0..<items.count {
                let imageName = imagesArr.object(at: i) as! String

                
                 tabBarImages = UIImage(named: imageName) // tabBarImages: [UIImage]

                let tabBarItem = items[i]
                let tabBarImage = tabBarImages
                tabBarItem.image = tabBarImage?.withRenderingMode(.alwaysOriginal)

                tabBarItem.selectedImage = tabBarImage
            }
        }
        
        if shadowViewCont != nil {
            
            shadowViewCont.view.frame = self.view.frame
            
            let newOrigin = -(self.view.frame.size.height - (self.leftViewController?.view.frame.size.height)!) - 5
            
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
                shadowViewCont.view.frame.origin.y = newOrigin
                if self.view.frame.size.height == 320 {
                    //shadowViewCont.view.frame.origin.y = -30
                }
            }
                
            else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                shadowViewCont.view.frame.origin.y = newOrigin
                if self.view.frame.size.height == 320 {
                   // shadowViewCont.view.frame.origin.y = -30
                }
            }
                
            else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                shadowViewCont.view.frame.origin.y = 0
            }
                
            else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
                shadowViewCont.view.frame.origin.y = 0
            }
            else {
                shadowViewCont.view.frame.origin.y = newOrigin
            }
            shadowViewCont.view.frame.size.height = (self.view.frame.size.height - shadowViewCont.view.frame.origin.y)
            print(shadowViewCont.view.frame.origin.y)
        }
        
        layerGradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.customTabBar.frame.size.height)

        let itemWidth = self.view.frame.size.width / CGFloat(self.customTabBar.items!.count)
        bgView.frame = CGRect(x: 0, y: 0, width: itemWidth, height: customTabBar.frame.height)
        bgView2.frame = CGRect(x: itemWidth*1, y: 0, width: itemWidth, height: customTabBar.frame.height)
        bgView3.frame = CGRect(x: itemWidth*2, y: 0, width: itemWidth, height: customTabBar.frame.height)
        bgView4.frame = CGRect(x: itemWidth*3, y: 0, width: itemWidth, height: customTabBar.frame.height)
        bgView5.frame = CGRect(x: itemWidth*4, y: 0, width: itemWidth, height: customTabBar.frame.height)
        
        
        if layoutUpdated == false {
            
            if self.slideMenuController()?.menuIsOpen == true {
                self.slideMenuController()?.menuIsOpen = false
                self.slideMenuController()?.closeRight()
            }
            layoutUpdated = true
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.customTabBar.selectedItem == self.dashboardItem {
            self.changeColorOfButton(view: self.bgView)
        }
        else if self.customTabBar.selectedItem == self.productItem {
            self.changeColorOfButton(view: self.bgView2)
        }
        else if self.customTabBar.selectedItem == self.CategoryItem {
            self.changeColorOfButton(view: self.bgView3)
        }
        else if self.customTabBar.selectedItem == self.customerItem {
            self.changeColorOfButton(view: self.bgView4)
        }
        else if self.customTabBar.selectedItem == self.orderItem {
            self.changeColorOfButton(view: self.bgView5)
        }


    }
    
    
    
    func MenuTapped(_ sender: Any) {
        if self.slideMenuController()?.menuIsOpen == false {
            //boolVal = 1
            layoutUpdated = true
            self.slideMenuController()?.openLeft()
        }
        else {
           // boolVal = 0
            self.slideMenuController()?.closeLeft()
        }
    }
   
    func leftDidOpen() {
        
        if shadowViewCont == nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            shadowViewCont = storyboard.instantiateViewController(withIdentifier: "ShadowViewCont") 
            self.addChildViewController(shadowViewCont)
            
        }
        
        self.view.insertSubview(shadowViewCont!.view!, belowSubview: self.customTabBar)

    }
    func leftDidClose() {
        
        if shadowViewCont != nil {
            shadowViewCont.view.removeFromSuperview()
        }
        //self.tabBar(self.customTabBar, didSelect: self.customTabBar.selectedItem!)
        
    }
    func showActionSheet() {
        let alertController = UIAlertController(title: "Multistore", message: "", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton1 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton2 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton3 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton4 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton5 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            self.tabBar(self.customTabBar, didSelect: self.customTabBar.selectedItem!)
        })
        alertController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        //        let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
        //            print("Delete button tapped")
        //        })
        
        //        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        //            print("Cancel button tapped")
        //        })
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        alertController.addAction(sendButton)
        alertController.addAction(sendButton1)
        alertController.addAction(sendButton2)
        alertController.addAction(sendButton3)
        alertController.addAction(sendButton4)
        alertController.addAction(sendButton5)
        //alertController.addAction(deleteButton)
        // alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheetLanguage() {
        
        let alertController = UIAlertController(title: "Multistore", message: "", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton1 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton2 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton3 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton4 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        let sendButton5 = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            self.tabBar(self.customTabBar, didSelect: self.customTabBar.selectedItem!)
        })
        alertController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        //        let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
        //            print("Delete button tapped")
        //        })
        
        //        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        //            print("Cancel button tapped")
        //        })
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        alertController.addAction(sendButton)
        alertController.addAction(sendButton1)
        alertController.addAction(sendButton2)
        alertController.addAction(sendButton3)
        alertController.addAction(sendButton4)
        alertController.addAction(sendButton5)
        //alertController.addAction(deleteButton)
        // alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        layoutUpdated = true

        switch item.tag {
            
        case 1:
            if viewController1 == nil {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController1 = storyboard.instantiateViewController(withIdentifier: "ViewController1") as? UITabBarController
                self.addChildViewController(viewController1!)

            }
            if self.leftViewController != nil {
                (self.leftViewController as! RightViewController).indexSelected = 2
                if (self.leftViewController as! RightViewController).menuTableView != nil {
                    (self.leftViewController as! RightViewController).menuTableView.reloadData()
                }
            }
            
            self.changeColorOfButton(view: self.bgView)
            //ShadowViewCont
            self.view.insertSubview(viewController1!.view!, belowSubview: self.customTabBar)
            break
            
            
        case 2:
            if viewController2_1 == nil {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController2_1 = storyboard.instantiateViewController(withIdentifier: "viewController2_1") as? UITabBarController
                self.addChildViewController(viewController2_1!)
            }
            if self.leftViewController != nil {
                (self.leftViewController as! RightViewController).indexSelected = 3
                if (self.leftViewController as! RightViewController).menuTableView != nil {
                    (self.leftViewController as! RightViewController).menuTableView.reloadData()
                }
            }
            self.changeColorOfButton(view: self.bgView2)

            self.view.insertSubview(viewController2_1!.view!, belowSubview: self.customTabBar)
            break
            
        case 3:
            if viewController2 == nil {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController2 = storyboard.instantiateViewController(withIdentifier: "ViewController2") as? UITabBarController
                self.addChildViewController(viewController2!)
            }
            if self.leftViewController != nil {
                (self.leftViewController as! RightViewController).indexSelected = 4
                if (self.leftViewController as! RightViewController).menuTableView != nil {
                    (self.leftViewController as! RightViewController).menuTableView.reloadData()
                }
            }
            
            self.changeColorOfButton(view: self.bgView3)

            self.view.insertSubview(viewController2!.view!, belowSubview: self.customTabBar)
            break
            
        case 4:
            if viewController3 == nil {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController3 = storyboard.instantiateViewController(withIdentifier: "ViewController3") as? UITabBarController
                self.addChildViewController(viewController3!)
                
            }
            if self.leftViewController != nil {
                (self.leftViewController as! RightViewController).indexSelected = 6
                if (self.leftViewController as! RightViewController).menuTableView != nil {
                    (self.leftViewController as! RightViewController).menuTableView.reloadData()
                }
            }
            
            self.changeColorOfButton(view: self.bgView4)

            self.view.insertSubview(viewController3!.view!, belowSubview: self.customTabBar)
            break
            
        case 5:
            if viewController4 == nil {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController4 = storyboard.instantiateViewController(withIdentifier: "ViewController4") as? UITabBarController
                self.addChildViewController(viewController4!)
                
            }
            if self.leftViewController != nil {
                (self.leftViewController as! RightViewController).indexSelected = 7
                if (self.leftViewController as! RightViewController).menuTableView != nil {
                    (self.leftViewController as! RightViewController).menuTableView.reloadData()
                }
            }
            
            self.changeColorOfButton(view: self.bgView5)

            self.view.insertSubview(viewController4!.view!, belowSubview: self.customTabBar)
            break
            
        default:
            break
            
        }
        
        
    }

    
    //MARK:- Customer Filter Screen
    
    @IBAction func applyTapped(_ sender: Any) {
        
        if currentSenderVC is OrderViewController {
            
            if (custNameTextF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                custNameTextF.text = ""
            }
            if (emailTextF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                emailTextF.text = ""
            }
            if (idTextF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                idTextF.text = "0"
            }
            
            if (dateMinTextF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                dateMinTextF.text = ""
                // startTimeStamp = 0
            }
            else {
                //startTimeStamp = Int(textF4.text!)!
            }
            if (dateMaxTextF.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                dateMaxTextF.text = ""
                //endTimeStamp = 0
            }
            else {
                //endTimeStamp = Int(textF5.text!)!
            }
            
            (currentSenderVC as! OrderViewController).sendDataOfOrder(name: custNameTextF.text!, id: Int(idTextF.text!)!, email: emailTextF.text!, fromDate: dateMinTextF.text!, toDate: dateMaxTextF.text!)
        }
        hideFilterView()
    }
    func filterTapped(_ senderVC: UIViewController) {
        
        currentSenderVC = senderVC
        
        self.filterBgView.isHidden = false
        filterBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideFilterView)))
        
        self.filterView.isHidden = false
        
    }
    
    func hideFilterView() {
        
        self.filterBgView.isHidden = true
        
        self.filterView.isHidden = true
    }
    
    func initDatePicker() {
        if self.timePicker == nil {
            self.timePicker = UIDatePicker()
            self.timePicker!.datePickerMode = UIDatePickerMode.date
            self.timePicker!.addTarget(self, action: #selector(self.updateDate), for: UIControlEvents.valueChanged)
            //self.timePicker!.minimumDate = Date()
            self.timePicker!.backgroundColor = UIColor.white
            self.dateMinTextF.inputView = self.timePicker
            self.dateMinTextF.inputAccessoryView = self.createPickerToolBar(pickerTextF: self.dateMinTextF)
        }
        if self.toTimePicker == nil {
            self.toTimePicker = UIDatePicker()
            self.toTimePicker!.datePickerMode = UIDatePickerMode.date
            self.toTimePicker!.addTarget(self, action: #selector(self.updateDateForToDate), for: UIControlEvents.valueChanged)
            self.toTimePicker!.minimumDate = Date()
            self.toTimePicker!.backgroundColor = UIColor.white
            self.dateMaxTextF.inputView = self.toTimePicker
            self.dateMaxTextF.inputAccessoryView = self.createPickerToolBar(pickerTextF: self.dateMaxTextF)
        }
    }
    
    func updateDate() {
        // let picker: UIDatePicker = self.dateMinTextF.inputView as! UIDatePicker
        //        var dateF = DateFormatter()
        //        dateF.dateFormat = "dd MMM yyyy"
        //self.date = picker.date as NSDate?
        //        self.delegate?.didIntroduceText(self.actionTextView.text.characters.count != 0 && self.searchableTableView?.getText().characters.count != 0 && self.dateLabel.text!.characters.count != 0)
    }
    func updateDateForToDate() {
        //let picker: UIDatePicker = self.dateMaxTextF.inputView as! UIDatePicker
        //self.dateMaxTextF.text = dateF.string(from: picker.date)
        //        self.delegate?.didIntroduceText(self.actionTextView.text.characters.count != 0 && self.searchableTableView?.getText().characters.count != 0 && self.dateLabel.text!.characters.count != 0)
    }
    
    func createPickerToolBar(pickerTextF:UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        var doneButton = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneAction))
        if pickerTextF == dateMaxTextF {
            doneButton = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneActionToDate))
        }
        //doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: kOpenSansRegular, size: kHeaderFontSize)!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        doneButton.accessibilityLabel = "DoneToolbar"
        
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelAction))
        if pickerTextF == dateMaxTextF {
            cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelActionToDate))
        }
        
        //cancelButton.accessibilityLabel = "DoneToolbar"
        
        var clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.clearAction))
        if pickerTextF == dateMaxTextF {
            clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.clearActionToDate))
        }
        
        //clearButton.accessibilityLabel = "DoneToolbar"
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.isTranslucent = false
        toolbar.sizeToFit()
        toolbar.setItems([clearButton,cancelButton,spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }
    
    func doneAction() {
        let dateF = DateFormatter()//
        dateF.dateFormat = "yyyy-MM-dd"
        
        self.date = self.timePicker?.date as NSDate?
        self.dateMinTextF.text = dateF.string(from: self.date as! Date)
        
        self.updateDate()
        self.dateMinTextF.resignFirstResponder()
        self.timePicker?.removeFromSuperview()
    }
    func doneActionToDate() {
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        
        
        self.dateTo = self.toTimePicker?.date as NSDate?
        self.dateMaxTextF.text = dateF.string(from: self.dateTo as! Date)
        
        self.updateDateForToDate()
        self.dateMaxTextF.resignFirstResponder()
        self.toTimePicker?.removeFromSuperview()
    }
    func cancelAction() {
        //self.updateDate()
        let picker: UIDatePicker = self.dateMinTextF.inputView as! UIDatePicker
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        if self.date != nil {
            self.dateMinTextF.text = dateF.string(from: self.date as! Date)
            picker.date = self.date as! Date
        }
        
        self.dateMinTextF.resignFirstResponder()
        self.timePicker?.removeFromSuperview()
    }
    func cancelActionToDate() {
        //self.updateDate()
        let picker: UIDatePicker = self.dateMaxTextF.inputView as! UIDatePicker
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        if self.dateTo != nil {
            self.dateMaxTextF.text = dateF.string(from: self.dateTo as! Date)
            picker.date = self.dateTo as! Date
        }
        self.dateMaxTextF.resignFirstResponder()
        self.toTimePicker?.removeFromSuperview()
    }
    func clearAction() {
        self.dateMinTextF.text = ""
        self.dateMinTextF.resignFirstResponder()
        self.timePicker?.removeFromSuperview()
    }
    func clearActionToDate() {
        self.dateMaxTextF.text = ""
        self.dateMaxTextF.resignFirstResponder()
        self.toTimePicker?.removeFromSuperview()
    }
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.filterScrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.filterScrollView.contentInset = contentInsets
        self.filterScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if (activeTextField) != nil
        {
            if (!aRect.contains(activeTextField.frame.origin))
            {
                self.filterScrollView.scrollRectToVisible(activeTextField.frame, animated: true)
            }
        }
        
        
    }
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        _ = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.filterScrollView.contentInset = contentInsets
        self.filterScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        //self.scrollView.isScrollEnabled = false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = UITextField()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
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
