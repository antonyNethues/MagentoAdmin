//
//  CustomTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit
import SwiftCharts

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var abandonedRevVallab: UILabel!
    @IBOutlet var abandonedRevlab: UILabel!
    @IBOutlet var abandonedCartValLab: UILabel!
    @IBOutlet var abandonedCartLab: UILabel!
    @IBOutlet var reloadButton: UIButton!
    @IBOutlet var pieChartDiscView: UIView!
    @IBOutlet var piePercentWidth4: NSLayoutConstraint!
    @IBOutlet var piePercentWidth3: NSLayoutConstraint!
    @IBOutlet var piePercentWidth2: NSLayoutConstraint!
    @IBOutlet var piePercentWidth1: NSLayoutConstraint!
    @IBOutlet var weekVisitLab: UILabel!
    @IBOutlet var weekVisitVallab: UILabel!
    
    @IBOutlet var weekRevLab: UILabel!
    @IBOutlet var weekRevValLab: UILabel!
    
    @IBOutlet var todayRevLab: UILabel!
    @IBOutlet var todayRevValLab: UILabel!
    
    @IBOutlet var todayVisitLab: UILabel!
    @IBOutlet var todayVisitValLab: UILabel!
    
    @IBOutlet var colorRev: UIView!
    @IBOutlet var labRev: UILabel!
    
    @IBOutlet var colorVisit: UIView!
    @IBOutlet var labVisit: UILabel!
    
    @IBOutlet var visitchartDetailView: UIView!
    @IBOutlet var visitChart: UIView!
    @IBOutlet var colorTax: UIView!
    @IBOutlet var labTax: UILabel!
    @IBOutlet var labTaxVal: UILabel!
    @IBOutlet var labTaxValP: UILabel!
    
    @IBOutlet var colorShip: UIView!
    @IBOutlet var labShip: UILabel!
    @IBOutlet var labShipVal: UILabel!
    @IBOutlet var labShipValP: UILabel!
    
    @IBOutlet var colorRef: UIView!
    @IBOutlet var labRefS: UILabel!
    @IBOutlet var labRefVS: UILabel!
    @IBOutlet var labRefVPS: UILabel!
    
    @IBOutlet var labNPVPF: UILabel!
    @IBOutlet var labNPVF: UILabel!
    @IBOutlet var labNPF: UILabel!
    @IBOutlet var colorNP : UIView!
    
    @IBOutlet var piechartSuperV: UIView!
    @IBOutlet var pieChartView: UIView!
    @IBOutlet var lineChartView: PNLineChart!
    @IBOutlet var barChartTitle: UILabel!
    @IBOutlet var cellTitleValWidthConst: NSLayoutConstraint!
    @IBOutlet var cellTitleVal: UILabel!
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var barCharView: SimpleBarChart!
    @IBOutlet var viewAllButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    var chart: Chart? // arc

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
