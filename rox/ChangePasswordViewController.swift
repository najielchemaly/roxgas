//
//  ChangePasswordViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/19/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var viewCurrentPassword: UIView!
    @IBOutlet weak var viewNewPassword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var textFieldCurrentPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textFieldCurrentPassword.delegate = self
        self.textFieldNewPassword.delegate = self
        self.textFieldConfirmPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "CHANGE PASSWORD"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appGreen)
            
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().changePassword(oldPassword: self.textFieldCurrentPassword.text!, newPassword: self.textFieldNewPassword.text!)
                
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        if let message = response?.message {
                            self.showAlert(title: "Change Password", message: message, style: .alert, shouldPop: true)
                        }
                    }
                    
                    self.removeAllOverlays()
                }
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    func initializeViews() {
        self.viewCurrentPassword.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewNewPassword.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewConfirmPassword.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldCurrentPassword {
            textFieldNewPassword.becomeFirstResponder()
        } else if textField == textFieldNewPassword {
            textFieldConfirmPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if (textFieldCurrentPassword.text?.isEmpty)! || (textFieldNewPassword.text?.isEmpty)! ||
            (textFieldConfirmPassword.text?.isEmpty)! {
            errorMessage = "Please fill all empty fields!"
            return false
        }
        
        if textFieldNewPassword.text != textFieldConfirmPassword.text {
            errorMessage = "Passwords do not match!"
            return false
        }
        
        return true
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
