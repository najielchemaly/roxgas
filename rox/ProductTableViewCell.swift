//
//  ProductTableViewCell.swift
//  rox
//
//  Created by MR.CHEMALY on 10/17/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var viewProductName: UIView!
    @IBOutlet weak var textFieldProductName: UITextField!
    @IBOutlet weak var viewProductQty: UIView!
    @IBOutlet weak var textFieldProductQty: UITextField!
    @IBOutlet weak var buttonDecreaseQty: UIButton!
    @IBOutlet weak var buttonIncreaseQty: UIButton!
    @IBOutlet weak var labelLeftBottomBorder: UILabel!
    @IBOutlet weak var labelRightBottomBorder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
