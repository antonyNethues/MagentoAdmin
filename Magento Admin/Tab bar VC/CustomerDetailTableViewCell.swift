//
//  CustomerDetailTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 28/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class CustomerDetailTableViewCell: UITableViewCell {

    @IBOutlet var bottomConst: NSLayoutConstraint!
    @IBOutlet var addressConst: NSLayoutConstraint!
    @IBOutlet var defBillingAdd: UILabel!
    
    @IBOutlet var lastLogInValLab: UILabel!
    
    
    @IBOutlet var lastLogInlab: UILabel!
    
    
    @IBOutlet var confEmailLab: UILabel!
    @IBOutlet var confEmailVallab: UILabel!
    
    @IBOutlet var accCreatOnLab: UILabel!
    @IBOutlet var accCreatOnValLab: UILabel!
    
    @IBOutlet var defBillAddValLab: UILabel!
    
    @IBOutlet var lifetLab: UILabel!
    @IBOutlet var lifeTValLab: UILabel!
    
    @IBOutlet var avgLab: UILabel!
    @IBOutlet var avgValLab: UILabel!
    
    @IBOutlet var orderLab: UILabel!
    @IBOutlet var orderVallab: UILabel!
    
    @IBOutlet var purchasedOnLab: UILabel!
    @IBOutlet var purchOnValLab: UILabel!
    
    @IBOutlet var billToNamLab: UILabel!
    @IBOutlet var billToNamValLab: UILabel!
    
    
    @IBOutlet var orderTotalLab: UILabel!
    @IBOutlet var orderTotalValLab: UILabel!
    
    
    @IBOutlet var defBIllingHeader: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
