//
//  SettingsViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/19/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolbarView.labelTitle.text = "SETTINGS"
        self.toolbarView.buttonBack.isHidden = true
        self.toolbarView.buttonBackLeadingConstraint.constant = -20
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonEditProfileTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.EditProfileViewController, type: .Push)
    }
    
    @IBAction func buttonChangePasswordTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.ChangePasswordViewController, type: .Push)
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "ROX", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            self.showWaitOverlay(color: Colors.appGreen)
            DispatchQueue.global(qos: .background).async {
                if let userId = DatabaseObjects.user.id {
                    let response = Services.init().logout(userId: String(describing: userId))
                    
                    DispatchQueue.main.async {
//                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                        let userDefaults = UserDefaults.standard
                        userDefaults.removeObject(forKey: "user")
                        userDefaults.removeObject(forKey: "access_token")
                        userDefaults.synchronize()
//                        }
                        
                        if let loginNavBar = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIds.LoginNavBar) as? UINavigationController {
                            appDelegate.window?.rootViewController = loginNavBar
                        }
                        
                        self.removeAllOverlays()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.popVC(toRoot: true)
                        self.removeAllOverlays()
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
