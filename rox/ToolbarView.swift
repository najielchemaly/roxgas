//
//  ToolbarView.swift
//  rox
//
//  Created by MR.CHEMALY on 10/16/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class ToolbarView: UIView {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonBackLeadingConstraint: NSLayoutConstraint!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func buttonBackTapped(_ sender: Any) {
        currentVC.popVC()
    }
    
}
