//
//  AppDefaults.swift
//  rox
//
//  Created by MR.CHEMALY on 10/16/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit

var currentVC: BaseViewController!
var isUserLoggedIn: Bool = false
var confirmationType: String!

let GMS_APIKEY = "AIzaSyAmVGdPOZuJ4qF3-ttE3YGYoNizKzpr9bw"
//let APPLE_LANGUAGE_KEY = "AppleLanguages"
//let DEVICE_LANGUAGE_KEY = "AppleLocale"

let paymentMethods = [
    "Cash",
    "Credit Card"
]

var appDelegate: AppDelegate {
    get {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        }
        
        return AppDelegate()
    }
}

struct Colors {
    
    static let appGreen: UIColor = UIColor(hexString: "#116068")!
    
}

struct Fonts {
    
    static let names: [String?] = UIFont.fontNames(forFamilyName: "")
    
    static var textFont_Light: UIFont {
        get {
            if let fontName = Fonts.names[0] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
    static var textFont_Regular: UIFont {
        get {
            if let fontName = Fonts.names[1] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
    static var textFont_Bold: UIFont {
        get {
            if let fontName = Fonts.names[2] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
}

struct StoryboardIds {
    
    static let LoginNavBar: String = "loginNavBar"
    static let MainTabBar: String = "mainTabBar"
    static let InitialViewController: String = "InitialViewController"
    static let LoginViewController: String = "LoginViewController"
    static let HomeViewController: String = "HomeViewController"
    static let SignupViewController: String = "SignupViewController"
    static let ConfirmationViewController: String = "ConfirmationViewController"
    static let HistoryViewController: String = "HistoryViewController"
    static let POSViewController: String = "POSViewController"
    static let PurchaseViewController: String = "PurchaseViewController"
    static let RefillViewController: String = "RefillViewController"
    static let ForgotPasswordViewController: String = "ForgotPasswordViewController"
    static let EditProfileViewController: String = "EditProfileViewController"
    static let SettingsViewController: String = "SettingsViewController"
    static let NotificationsViewController: String = "NotificationsViewController"
    static let ChangePasswordViewController: String = "ChangePasswordViewController"
    
}

enum Keys: String {
    
    case Access_Token = "access_token"
    case AccessToken = "AccessToken"
    case AppLanguage = "AppLanguage"
    case AppVersion = "AppVersion"
    
}

enum SegueId: String {
    
    case None
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
    
}

enum ConfirmationType: String {
    
    case Signup
    case Purchase
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
}

func getYears() -> NSMutableArray {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    let strDate = formatter.string(from: Date.init())
    if let intDate = Int(strDate) {
        let yearsArray: NSMutableArray = NSMutableArray()
        for i in (1964...intDate).reversed() {
            yearsArray.add(String(format: "%d", i))
        }
        
        return yearsArray
    }
    
    return NSMutableArray()
}

func isValidEmail(text:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: text)
}
