//
//  RightMenuTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 10/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class RightMenuTableViewCell: UITableViewCell {
    
    @IBOutlet var tableHeightConst: NSLayoutConstraint!
    @IBOutlet var topCellViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet var languageLab: UILabel!
    @IBOutlet var languageButton: UIButton!
    var selectedState = Bool()

    @IBOutlet var languageTable: UITableView!
    @IBOutlet var currencyTable: UITableView!
    @IBOutlet var menuLab: UILabel!
    @IBOutlet var menuSectionImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
