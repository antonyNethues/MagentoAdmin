//
//  MagentoTabBarController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 10/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class MagentoTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBar.barTintColor = UIColor(red: 237.0/255.0, green: 101.0/255.0, blue: 26.0/255, alpha: 1.0)
        //self.tabBar.selectedImageTintColor = UIColor.white
        self.tabBar.tintColor = ObjRef.sharedInstance.magentoOrange
        
        if #available(iOS 10.0, *) {
           // self.tabBar.unselectedItemTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
