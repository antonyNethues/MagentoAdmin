//
//  CustomerCollectionCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 23/02/18.
//  Copyright © 2018 Lokesh Gupta. All rights reserved.
//

import UIKit
import SwiftCharts

class CustomerCollectionCell: UICollectionViewCell {
    
    @IBOutlet var revLab: UILabel!
    @IBOutlet var colorRev: UIView!
    @IBOutlet var labCustomer: UILabel!
    @IBOutlet var colorCustomer: UIView!
    var chart: Chart? // arc

}
