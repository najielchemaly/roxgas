//
//  BaseViewController.swift
//  rox
//
//  Created by MR.CHEMALY on 10/16/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    var emptyLabel: UILabel!
    var toolbarView: ToolbarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
        
        if hasToolBar() {
            self.setupToolBarView()
        }                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentVC = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self is HomeViewController || self is NotificationsViewController || self is SettingsViewController || self is ConfirmationViewController {
            return  false
        }
    
        return true
    }
    
    func setupToolBarView() {
        let view = Bundle.main.loadNibNamed("ToolbarView", owner: self.view, options: nil)
        if let toolbarView = view?.first as? ToolbarView {
            self.toolbarView = toolbarView
            self.toolbarView.frame.size.width = self.view.frame.size.width
            self.toolbarView.frame.origin = CGPoint(x: 0, y: 50)
            self.view.addSubview(self.toolbarView)
        }
    }
    
    func hasToolBar() -> Bool {
        if self is LoginViewController || self is SignupViewController || self is ConfirmationViewController || self is HistoryViewController || self is POSViewController || self is PurchaseViewController || self is RefillViewController || self is ForgotPasswordViewController || self is EditProfileViewController || self is SettingsViewController || self is NotificationsViewController || self is ChangePasswordViewController {
            return true
        }
        
        return false
    }
    
    func addEmptyLabel(text: String) {
        if emptyLabel == nil {
            emptyLabel = UILabel()
            emptyLabel.frame.size = CGSize(width: self.view.frame.size.width-16, height: 100)
            emptyLabel.numberOfLines = 2
            emptyLabel.textColor = .black
            emptyLabel.textAlignment = .center
            emptyLabel.font = UIFont.init(name: "Gurmukhi MN", size: 18)
            emptyLabel.center = self.view.center
            
            self.view.addSubview(emptyLabel)
        }
        
        emptyLabel.text = text
        emptyLabel.alpha = 1
    }
    
    func removeEmptyLabel() {
        if emptyLabel != nil {
            emptyLabel.alpha = 0
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
