//
//  ViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/11/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class InitialViewController: BaseViewController {

    @IBOutlet weak var buttonSignin: UIButton!
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet weak var buttonWebsite: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonWebsiteTapped(_ sender: Any) {
        guard let url = URL(string: "http://www.roxgas.com") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

