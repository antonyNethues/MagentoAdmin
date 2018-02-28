//
//  ProductTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 10/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet var editButWidth: NSLayoutConstraint!
    @IBOutlet var childButWidth: NSLayoutConstraint!
    @IBOutlet var multiSelectConst2: NSLayoutConstraint!
    @IBOutlet var multiSelectionConst: NSLayoutConstraint!
    @IBOutlet var selectBut: UIButton!
    
    @IBOutlet var noChildConst: NSLayoutConstraint!
    @IBOutlet var moreSubcategory: UIButton!
    @IBOutlet var catLab: UILabel!
    @IBOutlet var catDeleteButton: UIButton!
    @IBOutlet var catEditButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
