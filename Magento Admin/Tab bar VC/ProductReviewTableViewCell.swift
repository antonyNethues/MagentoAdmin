//
//  ProductReviewTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 18/09/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class ProductReviewTableViewCell: UITableViewCell {

    @IBOutlet var reviewTitle: UILabel!
    @IBOutlet var reviewDesc: UILabel!
    @IBOutlet var reviewName: UILabel!
    @IBOutlet var userRating: HCSStarRatingView!
    @IBOutlet var approveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
