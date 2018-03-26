//
//  HistoryTableViewCell.swift
//  rox
//
//  Created by MR.CHEMALY on 10/17/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelOrderNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
