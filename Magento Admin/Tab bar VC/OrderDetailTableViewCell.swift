//
//  OrderDetailTableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 28/07/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    
    @IBOutlet var orderIdLab: UILabel!
    @IBOutlet var orderIdVallab: UILabel!
    
    @IBOutlet var orderDateLab: UILabel!
    @IBOutlet var orderDateVallab: UILabel!
    
    @IBOutlet var orderStatusLab: UILabel!
    @IBOutlet var orderStatusVallab: UILabel!
    
    
    @IBOutlet var custNameLab: UILabel!
    @IBOutlet var custNameValLab: UILabel!
    
    @IBOutlet var emailLab: UILabel!
    @IBOutlet var eamilValLab: UILabel!
    
    @IBOutlet var billingAddVal: UILabel!
    
    @IBOutlet var shippingAddVallab: UILabel!
    
    @IBOutlet var paymentInfoLab: UILabel!
    
    @IBOutlet var shippingLab: UILabel!
    @IBOutlet var shippingVallab: CurrencyLabel!
    
    @IBOutlet var prodnameLab: UILabel!
    @IBOutlet var prodNameValLab: UILabel!
    
    @IBOutlet var refCodeLab: UILabel!
    @IBOutlet var refCodeVallab: UILabel!
    
    @IBOutlet var priceLab: UILabel!
    @IBOutlet var priceValLab: CurrencyLabel!
    
    @IBOutlet var qtyLab: UILabel!
    @IBOutlet var qtyValLab: UILabel!
    
    @IBOutlet var subtotalLab: UILabel!
    @IBOutlet var subtotalValLab: CurrencyLabel!
    
    @IBOutlet var taxAmountLab: UILabel!
    @IBOutlet var taxAmtVallab: CurrencyLabel!
    
    @IBOutlet var discAmtLab: UILabel!
    @IBOutlet var discAmtVallab: CurrencyLabel!
    
    @IBOutlet var rowTotalLab: UILabel!
    @IBOutlet var rowTotalValLab: CurrencyLabel!
    
    @IBOutlet var subtotalOrderLab: UILabel!
    @IBOutlet var subtotalOrderVallab: CurrencyLabel!
    
    @IBOutlet var shipAndHandLab: UILabel!
    @IBOutlet var shipAndHandVallab: CurrencyLabel!
    
    @IBOutlet var taxLab: UILabel!
    @IBOutlet var taxValLab: CurrencyLabel!
    
    @IBOutlet var grandTotalLab: UILabel!
    @IBOutlet var grandTotalVallab: CurrencyLabel!
    
    @IBOutlet var totalPaidLab: UILabel!
    @IBOutlet var totalPaidValLab: CurrencyLabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
