//
//  CustomTabBar.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 13/10/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override open var traitCollection: UITraitCollection {
        //if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        //}
       // return super.traitCollection
    }

}
