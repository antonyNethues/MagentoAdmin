//
//  EditProd1TableViewCell.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 12/12/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class EditProd1TableViewCell: UITableViewCell {
    @IBOutlet var saveButton: UIButton!
   
    
    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var imageHeightConst: NSLayoutConstraint!
    @IBOutlet var imageSelected: UIImageView!
    @IBOutlet var catBut: UIButton!
    @IBOutlet var websiteTextF: UITextField!
    
    @IBOutlet var addFileBut: UIButton!
    @IBOutlet var addFileLab: UILabel!
    
    @IBOutlet var attSetBut: UIButton!
    @IBOutlet var attSetTextF: UITextField!
    
    @IBOutlet var stockAvlBut: UIButton!
    @IBOutlet var stockAvlTextF: UITextField!
    @IBOutlet var stockAvLab: UILabel!
    
    @IBOutlet var quantityTextF: UITextField!
    @IBOutlet var quantityLab: UILabel!
    
    
    @IBOutlet var taxClassButton: UIButton!
    @IBOutlet var taxClassTextF: UITextField!
    @IBOutlet var taxClassLab: UILabel!
    @IBOutlet var priceTextF: UITextField!
    @IBOutlet var priceLab: UILabel!

    @IBOutlet var shortDescTextv: UITextView!
    @IBOutlet var shortDesclab: UILabel!
    @IBOutlet var descTextv: UITextView!
    @IBOutlet var visibLab: UILabel!
    @IBOutlet var visibBut: UIButton!
    @IBOutlet var visibTextF: UITextField!
    @IBOutlet var descLab: UILabel!
    @IBOutlet var statusBut: UIButton!
    @IBOutlet var statusTextF: UITextField!
    @IBOutlet var statusLab: UILabel!
    @IBOutlet var weightTextF: UITextField!
    @IBOutlet var weightLab: UILabel!
    @IBOutlet var skuTextF: UITextField!
    @IBOutlet var skuLab: UILabel!
    @IBOutlet var nameTextF: UITextField!
    @IBOutlet var nameLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
