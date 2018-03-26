//
//  HistoryDetailTableViewCell.swift
//  rox
//
//  Created by MR.CHEMALY on 11/13/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class HistoryDetailTableViewCell: UITableViewCell {
   
    @IBOutlet weak var labelProduct: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
