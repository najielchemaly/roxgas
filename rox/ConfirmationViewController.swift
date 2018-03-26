//
//  ConfirmationViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/16/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class ConfirmationViewController: BaseViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if confirmationType.lowercased() == ConfirmationType.Signup.identifier.lowercased() {
            self.toolbarView.labelTitle.text = "SIGN UP"
            self.labelTitle.text = "THANK YOU FOR YOUR REGISTRATION!"
            self.labelDescription.text = "A confirmation email will be shortly sent to"
            self.labelEmail.text = DatabaseObjects.user.email
            self.buttonContinue.setTitle("Continue", for: .normal)
        } else {
            self.toolbarView.labelTitle.text = "ORDER SENT"
            self.labelTitle.text = "THANK YOU FOR YOUR ORDER!"
            self.labelDescription.text = "A copy for your order has been sent to your email"
            self.labelEmail.text = ""
            self.buttonContinue.setTitle("Done", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonContinueTapped(_ sender: Any) {
        if confirmationType.lowercased() == ConfirmationType.Signup.identifier.lowercased() {
            self.showWaitOverlay(color: Colors.appGreen)
            
            DispatchQueue.global(qos: .background).async {
                if let id = DatabaseObjects.user.id, let email = DatabaseObjects.user.email {
                    let response = Services.init().checkEmailConfirmation(id: String(describing: id), email: email)
                    
                    DispatchQueue.main.async {
                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                            if let json = response?.jsonArray?.last {
                                DatabaseObjects.user = User.init(dictionary: json)!
                                let userDefaults = UserDefaults.standard
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: DatabaseObjects.user)
                                userDefaults.set(encodedData, forKey: "user")
                                userDefaults.synchronize()
                            }
                            
                            self.redirectToVC(storyboardId: StoryboardIds.MainTabBar, type: .Push)
                        } else {
                            self.showAlert(message: (response?.message)!, style: .alert)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                }
            }
        } else {
            self.redirectToVC(storyboardId: StoryboardIds.MainTabBar, type: .Push)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
