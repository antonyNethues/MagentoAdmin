//
//  ProductListTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 04/10/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var productPrice: CurrencyLabel!
    @IBOutlet var productName: UILabel!
    @IBOutlet var ProductImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
