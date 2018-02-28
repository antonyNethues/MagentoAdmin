//
//  CurrencyLabel.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 11/01/18.
//  Copyright © 2018 Lokesh Gupta. All rights reserved.
//

import UIKit

class CurrencyLabel: UILabel {

    
    func updateCurrency(str : String) {
        self.text =  ObjRef.sharedInstance.currencyPrefix + str
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
