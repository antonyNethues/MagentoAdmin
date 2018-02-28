//
//  CustomerTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit
import SwiftCharts

class CustomerTableViewCell: UITableViewCell {

    
    @IBOutlet var labRevVal: UILabel!
    @IBOutlet var labRev: UILabel!
    @IBOutlet var valueWeekCustomer: UILabel!
    @IBOutlet var labWeekCust: UIView!
    @IBOutlet var buttonSelectYear: UIButton!
    @IBOutlet var buttonSelectMonth: UIButton!
    @IBOutlet var collectionViewCustomer: UICollectionView!
    @IBOutlet var cellRevLab: UILabel!
    @IBOutlet var chartTitle: UILabel!
    @IBOutlet var filterChartTitle: UILabel!
    @IBOutlet var monthFilterButton: UIButton!
    @IBOutlet var monthFilterLab: UILabel!
    @IBOutlet var yearFilterButton: UIButton!
    @IBOutlet var yearFilterLab: UILabel!
    @IBOutlet var viewAllButton: UIButton!
    @IBOutlet var cellTitleRevenueVal: UILabel!
    @IBOutlet var cellTitleVal: UILabel!
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var barCharView: SimpleBarChart!
    var chart: Chart? // arc

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
