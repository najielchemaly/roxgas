//
//  LoginViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/16/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSignin: UIButton!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.textFieldUsername.delegate = self
        self.textFieldPassword.delegate = self
        
//        self.initializeViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "SIGN IN"
        
        self.resetFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appGreen)
            
            DispatchQueue.global(qos: .background).async {
                let user = User()
                user.email = self.textFieldUsername.text
                user.password = self.textFieldPassword.text
                let response = Services.init().login(user: user)
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        if let json = response?.jsonArray?.first {
                            DatabaseObjects.user = User.init(dictionary: json)!
                        }
                        
                        if DatabaseObjects.user.id != nil && DatabaseObjects.user.id != 0 {
                            let userDefaults = UserDefaults.standard
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: DatabaseObjects.user)
                            userDefaults.set(encodedData, forKey: "user")
                            userDefaults.synchronize()
                            
                            self.redirectToVC(storyboardId: StoryboardIds.MainTabBar, type: .Push)
                        }
                    } else {
                        self.showAlert(message: (response?.message)!, style: .alert)
                        self.resetFields()
                    }
                
                    self.removeAllOverlays()
                }
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    func resetFields() {
        self.textFieldUsername.text = ""
        self.textFieldPassword.text = ""
    }
    
    func initializeViews() {
        self.viewUsername.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
        self.viewPassword.addBottomBorderWithColor(color: Colors.appGreen, width: 1)
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if !isValidEmail(text: textFieldUsername.text!) {
            errorMessage = "Please enter a valid email!"
            return false
        }
        
        if (textFieldPassword.text?.isEmpty)! {
            errorMessage = "Please fill all empty fields!"
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldUsername {
            textFieldPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
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
