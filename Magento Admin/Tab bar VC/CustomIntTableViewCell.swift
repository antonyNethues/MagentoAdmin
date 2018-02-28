//
//  CustomIntTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 27/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class CustomIntTableViewCell: UITableViewCell {

    @IBOutlet var phoneLabVal: UILabel!
    @IBOutlet var addressLabVal: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var usernameLab: UILabel!
    @IBOutlet var emailLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
