//
//  CustomLabel.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 04/10/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)))
    }
}
