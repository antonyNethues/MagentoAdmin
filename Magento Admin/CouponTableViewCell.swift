//
//  CouponTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 20/12/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {

    @IBOutlet var activeButton: UIButton!
    @IBOutlet var couponName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
