//
//  MultistoreViewController.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 18/12/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class MultistoreViewController: UIViewController {

    @IBOutlet var backShadowView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Multistore"
        //self.showActionSheet()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func menuTapped(_ sender: Any) {
        
        let vc = self.parent?.parent as! HomeViewController
        vc.MenuTapped(UIButton())
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
