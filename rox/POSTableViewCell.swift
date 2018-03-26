//
//  HistoryTableViewCell.swift
//  rox
//
//  Created by MR.CHEMALY on 10/17/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class POSTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var buttonGetLocation: UIButton!
    @IBOutlet weak var viewExpandable: UIView!
    @IBOutlet weak var labelExpand: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
