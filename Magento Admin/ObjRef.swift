//
//  ObjRef.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 03/10/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit


class ObjRef: NSObject {
    
    static let sharedInstance = ObjRef()
    var currencyPrefix = "$"
    var storeIdSelected = String()
    var userName = String()
    var userEmail = String()

    var magentoGreen = UIColor(red: 64/255.0, green: 92/255.0 , blue: 102/255.0, alpha: 1.0)
    var magentoOrange = UIColor(red: 249/255.0, green: 91/255.0 , blue: 33/255.0, alpha: 1.0)
    var magentoOrange2 = UIColor(red: 187/255.0, green: 106/255.0 , blue: 73/255.0, alpha: 1.0)
    var magentoGray = UIColor(red: 86/255.0, green: 86/255.0 , blue: 86/255.0, alpha: 1.0)
    
    func setCurrencyString(str : String) {
        currencyPrefix = str
    }
    func showAlertController(msg : String , superVC : UIViewController)  {
        
       // DispatchQueue.main.sync(execute: { () -> Void in
            let alertCont = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alertCont.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            superVC.present(alertCont, animated: true, completion: nil)
            
       // })
        
    }
    func updateFont(fontName : String,fontSize : Int) -> UIFont {
        
        let screenSize = UIScreen.main.bounds.size

        var minCorner = screenSize.width
        if minCorner > screenSize.height {
            minCorner = screenSize.height
        }
        let fontSizeUpdated = CGFloat(fontSize) * (minCorner / 320.0)

//        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
//            fontSizeUpdated = CGFloat(fontSize) * (screenSize.height / 320.0)
//        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
//            fontSizeUpdated = CGFloat(fontSize) * (screenSize.height / 320.0)
//        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
//            fontSizeUpdated = CGFloat(fontSize) * (screenSize.width / 320.0)
//
//        } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
//            fontSizeUpdated = CGFloat(fontSize) * (screenSize.width / 320.0)
//
//        }
        
        if fontName == "" {
            return UIFont.systemFont(ofSize: fontSizeUpdated)
        }

        return UIFont(name: fontName, size: CGFloat(fontSizeUpdated))!
        
    }
    
    func navigationbarLeftButton(viewController: UIViewController!, buttonImage: UIImage?) -> [UIBarButtonItem]
    {
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        //space.width = -30
        
        let btnRight = UIButton(frame: CGRect(x: -30, y: 0, width: (buttonImage?.size.width)!, height: 23))
        if UIScreen.main.bounds.size.width == 320 {
            //btnRight = UIButton(frame: CGRect(x: 10, y: 0, width: 20, height: 25.5))

        }
        //btnRight.backgroundColor = UIColor.blue
        btnRight.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        btnRight.titleLabel?.textAlignment = NSTextAlignment.left
        
        //			btnRight = UIButton(frame: CGRectMake(0, 0, buttonImage!.size.width, buttonImage!.size.height))
        btnRight.setImage(buttonImage, for: UIControlState.normal)
        //btnRight.backgroundColor = UIColor.red
        btnRight.addTarget(viewController, action: Selector(("navigationBtnLeftTapped")), for: UIControlEvents.touchUpInside)
        //btnRight.setTitle("Back", for: UIControlState.normal)
        btnRight.setTitle("", for: UIControlState.normal)
        btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        btnRight.setTitleColor(UIColor.white, for: UIControlState.normal)
        let barBtnRight = UIBarButtonItem(customView: btnRight)
        
        return [space, barBtnRight]
    }

    func setupNavigationBar(vc:UIViewController) {
//        vc.navigationController?.navigationBar.layer.borderColor = UIColor.white.cgColor
//        vc.navigationController?.navigationBar.layer.borderWidth=2;// set border you can see the shadow
        vc.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        vc.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        vc.navigationController?.navigationBar.layer.shadowRadius = 5.0
        vc.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        vc.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    func isEmptyOrContainsOnlySpaces(str:String) -> Bool {
        
        return str.trimmingCharacters(in: .whitespaces).characters.count == 0
    }
}
