//
//  ForgotPasswordViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/19/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonResetPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textFieldEmail.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "FORGOT PASSWORD"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonResetPasswordTapped(_ sender: Any) {
        if isValidEmail(text: textFieldEmail.text!) {
            self.showWaitOverlay(color: Colors.appGreen)
            
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().forgotPassword(email: self.textFieldEmail.text!)
                
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        
                    } else {
                        self.showAlert(message: (response?.message)!, style: .alert)
                    }
                    
                    self.removeAllOverlays()
                    self.textFieldEmail.text = ""
                }
            }
        } else {
            self.showAlert(message: "Please enter a valid email!", style: .alert)
        }
    }

    func initializeViews() {
        self.viewEmail.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        
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
