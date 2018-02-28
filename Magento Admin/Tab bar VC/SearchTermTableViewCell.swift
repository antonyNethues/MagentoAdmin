//
//  SearchTermTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 28/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class SearchTermTableViewCell: UITableViewCell {

    @IBOutlet var valSearchTerm: UILabel!
    @IBOutlet var valueResult: UILabel!
    @IBOutlet var valueUser: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
