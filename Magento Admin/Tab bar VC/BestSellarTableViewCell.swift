//
//  BestSellarTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 18/09/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class BestSellarTableViewCell: UITableViewCell {

    @IBOutlet var sellarProductName: UILabel!
    @IBOutlet var sellarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
