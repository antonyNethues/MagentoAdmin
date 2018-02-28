//
//  OrderTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var orderIdLab: UILabel!
    @IBOutlet var orderIdVal: UILabel!
    @IBOutlet var customerLab: UILabel!
    @IBOutlet var customerVal: UILabel!
    @IBOutlet var amountLab: UILabel!
    @IBOutlet var amountVal: UILabel!
    @IBOutlet var dateLab: UILabel!
    @IBOutlet var dateVal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
